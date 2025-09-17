#!/bin/bash
# Set to local prepare

# libpfring
rm -rf customfeeds/packages/libs/libpfring
mkdir -p customfeeds/packages/libs/libpfring/patches
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/libpfring/Makefile > customfeeds/packages/libs/libpfring/Makefile
pushd customfeeds/packages/libs/libpfring/patches
  curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/libpfring/patches/0001-fix-cross-compiling.patch
  curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/libpfring/patches/100-fix-compilation-warning.patch
  curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/libpfring/patches/900-fix-linux-6.6.patch
popd

# openvswitch
sed -i '/ovs_kmod_openvswitch_depends/a\\t\ \ +kmod-sched-act-sample \\' customfeeds/packages/net/openvswitch/Makefile

# rtpengine
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/rtpengine/900-fix-linux-6.12-11.5.1.18.patch > customfeeds/telephony/net/rtpengine/patches/900-fix-linux-6.12-11.5.1.18.patch

# routing - batman-adv fix build with linux-6.12
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/batman-adv/901-fix-linux-6.12rc2-builds.patch > customfeeds/routing/batman-adv/patches/901-fix-linux-6.12rc2-builds.patch

# sms-tools
mkdir -p customfeeds/packages/utils/sms-tool/patches
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/sms-tools/900-fix-incompatible-pointer-type-error-for-signal-function.patch > customfeeds/packages/utils/sms-tool/patches/900-fix-incompatible-pointer-type-error-for-signal-function.patch

# bind
# rm -rf customfeeds/packages/net/bind
# git clone --depth=1 https://github.com/xuanranran/feeds_packages_net_bind customfeeds/packages/net/bind

# boost
# curl -s https://raw.githubusercontent.com/openwrt/packages/3585ddfc446c38721d3ca4d1c708cbd9d3114726/libs/boost/Makefile > customfeeds/packages/libs/boost/Makefile
