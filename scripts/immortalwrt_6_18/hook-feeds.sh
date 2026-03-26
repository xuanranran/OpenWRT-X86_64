#!/bin/bash
# Set to local feeds
pushd customfeeds/lovepackages
export lovepackages_feed="$(pwd)"
popd
pushd customfeeds/loverely
export loverely_feed="$(pwd)"
popd

pushd customfeeds/packages
export packages_feed="$(pwd)"
popd
pushd customfeeds/luci
export luci_feed="$(pwd)"
popd

pushd customfeeds/routing
export routing_feed="$(pwd)"
popd
pushd customfeeds/telephony
export telephony_feed="$(pwd)"
popd

sed -i '/src-git lovepackages/d' feeds.conf.default
echo "src-link lovepackages $lovepackages_feed" >> feeds.conf.default
sed -i '/src-git loverely/d' feeds.conf.default
echo "src-link loverely $loverely_feed" >> feeds.conf.default

sed -i '/src-git packages/d' feeds.conf.default
echo "src-link packages $packages_feed" >> feeds.conf.default
sed -i '/src-git luci/d' feeds.conf.default
echo "src-link luci $luci_feed" >> feeds.conf.default

sed -i '/src-git routing/d' feeds.conf.default
echo "src-link routing $routing_feed" >> feeds.conf.default
sed -i '/src-git telephony/d' feeds.conf.default
echo "src-link telephony $telephony_feed" >> feeds.conf.default

# Update feeds
./scripts/feeds update -a
