#!/usr/bin/env python3
"""Stage private source and a pinned native core without persisting credentials."""
import argparse
import base64
import gzip
import hashlib
import importlib.util
import io
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.parse
import urllib.request

REPOSITORY = "xuanranran/openwrt-cnspeedtest"
API = "https://api.github.com/repos/" + REPOSITORY
LIMIT = 8 * 1024 * 1024


class NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None


def fetch(url, token=None, binary=False):
    """Never forward the API Authorization header to a redirected asset host."""
    parsed = urllib.parse.urlsplit(url)
    if parsed.scheme != "https" or parsed.username or parsed.password:
        raise RuntimeError("Unsafe release URL")
    if token and parsed.netloc != "api.github.com":
        raise RuntimeError("Refusing credentials outside the GitHub API")
    headers = {"User-Agent": "cnspeedtest-firmware-hook",
               "Accept": "application/octet-stream" if binary else "application/vnd.github+json"}
    if token:
        headers["Authorization"] = "Bearer " + token
    request = urllib.request.Request(url, headers=headers)
    opener = urllib.request.build_opener(NoRedirect())
    for attempt in range(3):
        try:
            with opener.open(request, timeout=30) as response:
                data = response.read(LIMIT + 1)
            if len(data) > LIMIT:
                raise RuntimeError("Oversized release response")
            return data
        except urllib.error.HTTPError as error:
            if error.code in (301, 302, 303, 307, 308) and token and binary:
                location = error.headers.get("Location", "")
                target = urllib.parse.urlsplit(location)
                if target.scheme != "https" or not target.hostname or not target.hostname.endswith(".githubusercontent.com"):
                    raise RuntimeError("Unexpected release redirect") from None
                return fetch(location, binary=True)  # Deliberately unauthenticated.
            if error.code not in (429, 500, 502, 503, 504) or attempt == 2:
                raise RuntimeError(f"GitHub request failed (HTTP {error.code}); check CNSPEEDTEST_TOKEN Contents: read access") from None
        except (urllib.error.URLError, TimeoutError, OSError):
            if attempt == 2:
                raise RuntimeError("Release download failed after three attempts") from None
        time.sleep(attempt + 1)


def setting(text, key, pattern):
    matches = re.findall(r"^" + re.escape(key) + r":=([^\n]+)$", text, re.M)
    if len(matches) != 1 or not re.fullmatch(pattern, matches[0].strip()):
        raise RuntimeError("Invalid native package setting: " + key)
    return matches[0].strip()


def identity(repo, core):
    recipe = (repo / "cnspeedtest/Makefile").read_text(encoding="utf-8")
    mapping = (repo / "cnspeedtest/architectures.mk").read_text(encoding="utf-8")
    version = setting(recipe, "PKG_VERSION", r"[0-9]+\.[0-9]+\.[0-9]+")
    release = setting(recipe, "PKG_RELEASE", r"[0-9]+")
    asset = setting(mapping, "CORE_ASSET_" + core, r"[a-z0-9-]+")
    expected = setting(recipe, "CORE_HASH_" + core, r"[0-9a-f]{64}")
    tag = f"core-{version}-r{release}"
    return tag, f"cnspeedtest-{asset}-v{version}-r{release}.gz", expected


def verify(data, expected, core, repo):
    if hashlib.sha256(data).hexdigest() != expected:
        raise RuntimeError("Native release SHA256 differs from the package pin")
    # Reuse the package's full ELF class/endian/static-linkage/ABI validation.
    sys.dont_write_bytecode = True
    sys.path.insert(0, str(repo / "scripts"))
    spec = importlib.util.spec_from_file_location("cnspeedtest_core_assets", repo / "scripts/core_assets.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    with gzip.GzipFile(fileobj=io.BytesIO(data)) as compressed:
        raw = compressed.read(2 * 1024 * 1024 + 1)
    if len(raw) > 2 * 1024 * 1024:
        raise RuntimeError("Oversized native executable")
    manifest = json.loads((repo / "scripts/architectures.json").read_text(encoding="utf-8"))
    module.validate_elf(raw, manifest["cores"][core])


def prepare(root, core, token):
    if not token:
        raise RuntimeError("CNSPEEDTEST_TOKEN is required for private source and Release assets")
    if not (root / "rules.mk").is_file() or not (root / "include/package.mk").is_file():
        raise RuntimeError("Run this hook from the OpenWrt source root")
    community = root / "package/community"
    community.mkdir(parents=True, exist_ok=True)
    target = community / "openwrt-cnspeedtest"
    dl = root / "dl"
    if community.is_symlink() or target.is_symlink() or dl.is_symlink():
        raise RuntimeError("Refusing symlinked package/cache directories")
    env = {k: v for k, v in os.environ.items()
           if not k.startswith("GIT_TRACE") and k != "GIT_CURL_VERBOSE"}
    auth = base64.b64encode(("x-access-token:" + token).encode()).decode()
    env.update(GIT_CONFIG_COUNT="1", GIT_CONFIG_KEY_0="http.https://github.com/.extraheader",
               GIT_CONFIG_VALUE_0="AUTHORIZATION: basic " + auth, GIT_TERMINAL_PROMPT="0")
    # Keep the old checkout and download intact until the replacement verifies.
    with tempfile.TemporaryDirectory(prefix=".cnspeedtest-", dir=community) as temporary:
        staging = Path(temporary)
        repo = staging / "repo"
        subprocess.run(["git", "clone", "--depth=1", "--branch", "master",
                        "https://github.com/" + REPOSITORY + ".git", str(repo)], env=env, check=True)
        tag, name, expected = identity(repo, core)
        dl.mkdir(exist_ok=True)
        cached = dl / name
        if cached.is_symlink():
            raise RuntimeError("Refusing symlinked native cache file")
        data = cached.read_bytes() if cached.is_file() and cached.stat().st_size <= LIMIT else b""
        cache_hit = bool(data) and hashlib.sha256(data).hexdigest() == expected
        if not cache_hit:
            release = json.loads(fetch(API + "/releases/tags/" + tag, token))
            if release.get("tag_name") != tag or release.get("draft"):
                raise RuntimeError("Pinned native release is unavailable")
            matches = [a for a in release.get("assets", []) if a.get("name") == name]
            if len(matches) != 1 or type(matches[0].get("id")) is not int:
                raise RuntimeError("Pinned architecture asset is missing or ambiguous")
            data = fetch(API + "/releases/assets/" + str(matches[0]["id"]), token, binary=True)
        verify(data, expected, core, repo)
        if not cache_hit:
            # Staging and destination can be separate filesystems; atomically
            # replace from a temporary file in dl, never expose a partial asset.
            with tempfile.NamedTemporaryFile(prefix=".cnspeedtest-", dir=dl, delete=False) as output:
                temporary_asset = Path(output.name)
                output.write(data)
            try:
                os.replace(temporary_asset, cached)
            finally:
                temporary_asset.unlink(missing_ok=True)
        previous = staging / "previous"
        if target.exists():
            target.rename(previous)
        try:
            repo.rename(target)
        except OSError:
            if previous.exists():
                previous.rename(target)
            raise
    print(f"cnspeedtest: {tag}, {core}, SHA256 and ELF verified; native asset ready in dl")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("core", choices=("x86_64", "aarch64"))
    args = parser.parse_args()
    try:
        prepare(Path.cwd().resolve(), args.core, os.environ.get("CNSPEEDTEST_TOKEN", ""))
    except (RuntimeError, AssertionError, OSError, ValueError, subprocess.CalledProcessError) as error:
        # HTTP errors/signed redirect URLs and credentials are never printed.
        print("cnspeedtest preparation failed: " + str(error), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
