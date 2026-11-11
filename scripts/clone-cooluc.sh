#!/bin/bash
# Retry the original source before using its GitHub backup.
set -eu

primary=$1
fallback=$2
destination=$3
parent=$(dirname -- "$destination")
mkdir -p -- "$parent"
workdir=$(mktemp -d "$parent/.clone-cooluc.XXXXXX")
trap 'rm -rf -- "$workdir"' EXIT

for source in "$primary" "$fallback"; do
    for attempt in 1 2 3; do
        echo "Cloning $source (attempt $attempt/3)"
        if git -c http.version=HTTP/1.1 \
            -c http.lowSpeedLimit=1024 -c http.lowSpeedTime=30 \
            clone --depth=1 "$source" "$workdir/repository"; then
            rm -rf -- "$destination"
            mv -- "$workdir/repository" "$destination"
            exit 0
        fi
        rm -rf -- "$workdir/repository"
        if [ "$attempt" -lt 3 ]; then
            sleep 2
        fi
    done
done

echo "Failed to clone both $primary and $fallback" >&2
exit 1
