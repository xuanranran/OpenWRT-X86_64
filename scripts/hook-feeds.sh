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
# rm -rf config/Config-kernel.in
# rm -rf package/kernel/linux/modules/video.mk
rm -rf package/kernel/linux/modules/netsupport.mk
rm -rf toolchain/gcc/*
# rm -rf package/libs/elfutils
# rm -rf tools/elfutils
rm -rf package/network/utils/uqmi
rm -rf customfeeds/packages/lang/node/*
rm -rf customfeeds/packages/lang/node-yarn/*
rm -rf customfeeds/packages/net/nginx-util/*
rm -rf customfeeds/packages/net/{*alist,chinadns-ng,dns2socks,dns2tcp,lucky,sing-box}

# Update GCC 13.3.0
pushd toolchain/gcc/
git clone --depth 1 https://github.com/immortalwrt/immortalwrt gcc && mv -n gcc/toolchain/gcc/* ./ ; rm -rf gcc
popd

# Update node 20.x
pushd customfeeds/packages/lang/node/
git clone --depth 1 https://github.com/immortalwrt/packages immortalwrt && mv -n immortalwrt/lang/node/* ./ ; rm -rf immortalwrt
popd

# Update node-yarn
pushd customfeeds/packages/lang/node-yarn/
git clone --depth 1 https://github.com/immortalwrt/packages immortalwrt && mv -n immortalwrt/lang/node-yarn/* ./ ; rm -rf immortalwrt
popd

# Update nginx-util
pushd customfeeds/packages/net/nginx-util/
git clone --depth 1 https://github.com/immortalwrt/packages nginxutil && mv -n nginxutil/net/nginx-util/* ./ ; rm -rf nginxutil
popd

# Update golang 1.23.x
rm -rf customfeeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang customfeeds/packages/lang/golang
# git clone https://github.com/sbwml/packages_lang_golang -b 23.x customfeeds/packages/lang/golang

# Update dnsmasq
# rm -rf package/network/services/dnsmasq/*
# pushd package/network/services/dnsmasq/
# git clone --depth 1 https://github.com/immortalwrt/immortalwrt immortalwrt && mv -n immortalwrt/package/network/services/dnsmasq/* ./ ; rm -rf immortalwrt
# popd

# Update rust
# rm -rf customfeeds/packages/lang/rust/*
# pushd customfeeds/packages/lang/rust/
# git clone --depth 1 https://github.com/immortalwrt/packages rust && mv -n rust/lang/rust/* ./ ; rm -rf rust
# popd

# cp -r $GITHUB_WORKSPACE/data/package/kernel/linux/modules/video.mk package/kernel/linux/modules/video.mk
# cp -r $GITHUB_WORKSPACE/data/config/Config-kernel.in config/Config-kernel.in
cp -r $GITHUB_WORKSPACE/data/package/kernel/linux/modules/netsupport.mk package/kernel/linux/modules/netsupport.mk
cp -r $GITHUB_WORKSPACE/data/package/network/utils/bpftool package/network/utils/bpftool
cp -r $GITHUB_WORKSPACE/data/package/network/utils/uqmi package/network/utils/uqmi
cp -r $GITHUB_WORKSPACE/data/xdp-tools package/network/utils/xdp-tools
# cp -r $GITHUB_WORKSPACE/data/package/libs/elfutils package/libs/elfutils
# cp -r $GITHUB_WORKSPACE/data/tools/elfutils tools/elfutils
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
./scripts/feeds clean -a
./scripts/feeds update -a
