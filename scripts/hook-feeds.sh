#!/bin/bash
# Set to local feeds
pushd customfeeds/packages
export packages_feed="$(pwd)"
popd
pushd customfeeds/luci
export luci_feed="$(pwd)"
popd
# rm -rf package/network/utils/uqmi
# cp -r $GITHUB_WORKSPACE/data/uqmi package/network/utils/uqmi
cp -r $GITHUB_WORKSPACE/data/xdp-tools package/network/utils/xdp-tools
# cp -r $GITHUB_WORKSPACE/data/pcre2 customfeeds/packages/libs/pcre2
sed -i '/src-git packages/d' feeds.conf.default
echo "src-link packages $packages_feed" >> feeds.conf.default
sed -i '/src-git luci/d' feeds.conf.default
echo "src-link luci $luci_feed" >> feeds.conf.default

# Update feeds
./scripts/feeds update -a
