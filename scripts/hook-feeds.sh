#!/bin/bash
# Set to local feeds
pushd customfeeds/packages
export packages_feed="$(pwd)"
popd
pushd customfeeds/luci
export luci_feed="$(pwd)"
popd
rm -rf config/Config-kernel.in
rm -rf package/kernel/linux/modules/netsupport.mk
rm -rf toolchain/gcc/*
rm -rf package/libs/elfutils
rm -rf package/network/utils/uqmi
rm -rf customfeeds/packages/lang/node/*
pushd toolchain/gcc/
git clone --depth 1 https://github.com/immortalwrt/immortalwrt immortalwrt && mv -n immortalwrt/toolchain/gcc/* ./ ; rm -rf immortalwrt
popd

pushd customfeeds/packages/lang/node/
git clone --depth 1 https://github.com/immortalwrt/packages immortalwrt && mv -n immortalwrt/lang/node/* ./ ; rm -rf immortalwrt
popd

cp -r $GITHUB_WORKSPACE/data/package/network/utils/uqmi package/network/utils/uqmi
cp -r $GITHUB_WORKSPACE/data/config/Config-kernel.in config/Config-kernel.in
cp -r $GITHUB_WORKSPACE/data/netsupport.mk package/kernel/linux/modules/netsupport.mk
cp -r $GITHUB_WORKSPACE/data/xdp-tools package/network/utils/xdp-tools
cp -r $GITHUB_WORKSPACE/data/package/libs/elfutils package/libs/elfutils
sed -i '/src-git packages/d' feeds.conf.default
echo "src-link packages $packages_feed" >> feeds.conf.default
sed -i '/src-git luci/d' feeds.conf.default
echo "src-link luci $luci_feed" >> feeds.conf.default

# Update feeds
./scripts/feeds clean
./scripts/feeds update -a
