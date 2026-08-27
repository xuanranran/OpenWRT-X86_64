#!/bin/bash
# Clone community packages to package/community
mkdir package/community
pushd package/community

# Add openwrt-packages
git clone --depth=1 https://github.com/xuanranran/openwrt-package openwrt-package
git clone --depth=1 https://github.com/xuanranran/rely openwrt-rely
git clone --depth=1 https://github.com/sbwml/wwan-packages wwan-packages
popd

# Update OpenClash Panel
pushd customfeeds/lovepackages/luci-app-openclash/root/usr/share/openclash/ui/
rm -rf yacd zashboard metacubexd/*
curl -sSL https://codeload.github.com/haishanh/yacd/zip/refs/heads/gh-pages -o yacd-dist-cdn-fonts.zip
curl -sSL https://github.com/MetaCubeX/metacubexd/releases/latest/download/compressed-dist.tgz -o compressed-dist.tgz
curl -sSL https://github.com/Zephyruso/zashboard/archive/refs/heads/gh-pages-cdn-fonts.zip -o dist-cdn-fonts.zip
tar zxf compressed-dist.tgz -C ./metacubexd
unzip -q dist-cdn-fonts.zip && unzip -q yacd-dist-cdn-fonts.zip
mv zashboard-gh-pages-cdn-fonts zashboard && mv yacd-gh-pages yacd
rm -rf yacd-dist-cdn-fonts.zip dist-cdn-fonts.zip compressed-dist.tgz
popd

# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# Modify default IP
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate
sed -i "s/ImmortalWrt/OpenWrt/g" package/base-files/files/bin/config_generate

# 修改开源站地址 (按内容删除国内镜像, 避免行号漂移破坏 JSON)
sed -i '\#mirror.iscas.ac.cn/kernel.org#d; \#mirrors.ustc.edu.cn/kernel.org#d; \#mirror.nju.edu.cn/kernel.org#d; \#mirrors.ustc.edu.cn/gnome#d; \#mirror.nju.edu.cn/gnome#d' scripts/projectsmirrors.json

# Prefer the MIT kernel mirror for the New York runner
sed -i '/"@KERNEL": \[/,/]/ {
  s#"https://cdn.kernel.org/pub"#"https://kernel-mirror-placeholder"#
  s#"https://mirrors.mit.edu/kernel"#"https://cdn.kernel.org/pub"#
  s#"https://kernel-mirror-placeholder"#"https://mirrors.mit.edu/kernel"#
}' scripts/projectsmirrors.json

# Prefer the official Samba source; keep other mirrors as fallbacks
samba_makefile="customfeeds/packages/net/samba4/Makefile"
if [ -f "$samba_makefile" ]; then
  sed -i '\#https://download.samba.org/pub/samba/stable/#d; \#https://www.nic.funet.fi/index/samba/pub/samba/stable/#s/[[:space:]]*\\$//; /^PKG_SOURCE_URL:= \\/a\        https://download.samba.org/pub/samba/stable/ \\' "$samba_makefile"
fi

sed -i 's/services/network/g' customfeeds/luci/applications/luci-app-upnp/root/usr/share/luci/menu.d/luci-app-upnp.json
sed -i 's/services/vpn/g' customfeeds/luci/applications/luci-app-frpc/root/usr/share/luci/menu.d/luci-app-frpc.json
sed -i 's/services/network/g' customfeeds/luci/applications/luci-app-3cat/root/usr/share/luci/menu.d/luci-app-3cat.json
sed -i 's/services/vpn/g' customfeeds/luci/applications/luci-app-tailscale-community/root/usr/share/luci/menu.d/luci-app-tailscale-community.json

# other
rm -rf target/linux/x86/base-files/etc/board.d/02_network
rm -rf package/base-files/files/etc/banner
cp -f $GITHUB_WORKSPACE/data/banner package/base-files/files/etc/banner
cp -f $GITHUB_WORKSPACE/data/02_network target/linux/x86/base-files/etc/board.d/02_network

# Add private cnspeedtest packages
rm -rf package/community/openwrt-cnspeedtest
if [ -z "$CNSPEEDTEST_TOKEN" ]; then
  echo "CNSPEEDTEST_TOKEN is not configured; skipping private cnspeedtest packages"
else
  CNSPEEDTEST_AUTH="$(printf 'x-access-token:%s' "$CNSPEEDTEST_TOKEN" | base64 | tr -d '\n')"
  GIT_CONFIG_COUNT=1 \
  GIT_CONFIG_KEY_0=http.https://github.com/.extraheader \
  GIT_CONFIG_VALUE_0="AUTHORIZATION: basic $CNSPEEDTEST_AUTH" \
  git clone --depth=1 --branch master \
    https://github.com/xuanranran/openwrt-cnspeedtest.git \
    package/community/openwrt-cnspeedtest
  unset CNSPEEDTEST_AUTH
fi
