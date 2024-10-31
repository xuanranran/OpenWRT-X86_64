#!/bin/bash
# Set to local prepare

rm -rf package/emortal/autocore
git clone https://github.com/sbwml/autocore-arm -b openwrt-23.05 package/emortal/autocore

# custom packages
rm -rf customfeeds/luci/applications/luci-app-filebrowser
rm -rf customfeeds/packages/net/shadowsocks-libev

rm -rf customfeeds/packages/net/{*alist,chinadns-ng,dns2socks,dns2tcp,lucky,sing-box}
# chmod 755 customfeeds/lovepackages/luci-app-onliner/root/usr/share/onliner/setnlbw.sh

# Update applications/luci-app-firewall
# rm -rf customfeeds/luci/applications/luci-app-firewall
# cp -r $GITHUB_WORKSPACE/data/luci/applications/luci-app-firewall customfeeds/luci/applications/luci-app-firewall

# rm -rf package/kernel/linux/modules/netsupport.mk
# cp -r $GITHUB_WORKSPACE/data/package/kernel/linux/modules/netsupport.mk package/kernel/linux/modules/netsupport.mk

# luci-app-turboacc
# sed -i 's/kmod-tcp-bbr/kmod-tcp-bbr3/g' customfeeds/luci/applications/luci-app-turboacc/Makefile

# xdp-tools
# cp -r $GITHUB_WORKSPACE/data/package/network/utils/xdp-tools package/network/utils/xdp-tools

# uqmi
# rm -rf package/network/utils/uqmi
# cp -r $GITHUB_WORKSPACE/data/package/network/utils/uqmi package/network/utils/uqmi

# uwsgi - bump version
# rm -rf customfeeds/packages/net/uwsgi
# cp -r $GITHUB_WORKSPACE/data/packages-master/net/uwsgi customfeeds/packages/net/uwsgi

# Update node 20.x
# rm -rf customfeeds/packages/lang/node
# git clone https://github.com/sbwml/feeds_packages_lang_node-prebuilt customfeeds/packages/lang/node

# Update node-yarn
# rm -rf customfeeds/packages/lang/node-yarn/*
# pushd customfeeds/packages/lang/node-yarn/
# git clone --depth 1 https://github.com/immortalwrt/packages immortalwrt && mv -n immortalwrt/lang/node-yarn/* ./ ; rm -rf immortalwrt
# popd

# unzip
# rm -rf customfeeds/packages/utils/unzip
# git clone https://github.com/sbwml/feeds_packages_utils_unzip customfeeds/packages/utils/unzip

# tcp-brutal
# git clone https://github.com/sbwml/package_kernel_tcp-brutal package/kernel/tcp-brutal

# Update nginx-util
rm -rf customfeeds/packages/net/nginx-util/*
pushd customfeeds/packages/net/nginx-util/
git clone --depth 1 https://github.com/immortalwrt/packages nginxutil && mv -n nginxutil/net/nginx-util/* ./ ; rm -rf nginxutil
popd

# Update golang 1.23.x
rm -rf customfeeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang customfeeds/packages/lang/golang
# git clone https://github.com/sbwml/packages_lang_golang -b 23.x customfeeds/packages/lang/golang

# Update GCC 13.3.0
# rm -rf toolchain/gcc/*
# pushd toolchain/gcc/
# git clone --depth 1 https://github.com/immortalwrt/immortalwrt gcc && mv -n gcc/toolchain/gcc/* ./ ; rm -rf gcc
# popd

# Update busybox
# rm -rf package/utils/busybox
# pushd package/utils/
# git clone --depth 1 https://github.com/immortalwrt/immortalwrt busybox && mv -n busybox/package/utils/busybox ./ ; rm -rf busybox
# popd


# Update iproute2
# rm -rf package/network/utils/iproute2
# pushd package/network/utils/
# git clone --depth 1 https://github.com/sbwml/package_network_utils_iproute2 iproute2
# popd

# Update dnsmasq
# rm -rf package/network/services/dnsmasq/*
# pushd package/network/services/dnsmasq/
# git clone --depth 1 https://github.com/immortalwrt/immortalwrt immortalwrt && mv -n immortalwrt/package/network/services/dnsmasq/* ./ ; rm -rf immortalwrt
# popd
# dnsmasq drop extraconftext parameter
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/dnsmasq/0001-dnsmasq-drop-extraconftext-parameter.patch | patch -p1

# tools: add upx tools
# rm -rf tools/Makefile
# cp -r $GITHUB_WORKSPACE/data/tools/upx tools/upx
# cp -r $GITHUB_WORKSPACE/data/tools/Makefile tools/Makefile

# lantiq
# rm -rf package/kernel/lantiq
# git clone --depth 1 https://github.com/xuanranran/package_kerne_lantiq package/kernel/lantiq

# apk-tools
# curl -s https://init2.cooluc.com/openwrt/patch/apk-tools/9999-hack-for-linux-pre-releases.patch > package/system/apk/patches/9999-hack-for-linux-pre-releases.patch

# ddns - fix boot
# sed -i '/boot()/,+2d' customfeeds/packages/net/ddns-scripts/files/ddns.init

# nlbwmon - disable syslog
# sed -i 's/stderr 1/stderr 0/g' customfeeds/packages/net/nlbwmon/files/nlbwmon.init

# samba4 - bump version
rm -rf customfeeds/packages/net/samba4
git clone https://github.com/sbwml/feeds_packages_net_samba4 customfeeds/packages/net/samba4
sed -i 's/ftp.gwdg.de/download.samba.org/g' customfeeds/packages/net/samba4/Makefile

# liburing - 2.7 (samba-4.21.0)
rm -rf customfeeds/packages/libs/liburing
git clone https://github.com/sbwml/feeds_packages_libs_liburing customfeeds/packages/libs/liburing
# enable multi-channel
sed -i '/workgroup/a \\n\t## enable multi-channel' customfeeds/packages/net/samba4/files/smb.conf.template
sed -i '/enable multi-channel/a \\tserver multi channel support = yes' customfeeds/packages/net/samba4/files/smb.conf.template
# default config
sed -i 's/#aio read size = 0/aio read size = 0/g' customfeeds/packages/net/samba4/files/smb.conf.template
sed -i 's/#aio write size = 0/aio write size = 0/g' customfeeds/packages/net/samba4/files/smb.conf.template
sed -i 's/invalid users = root/#invalid users = root/g' customfeeds/packages/net/samba4/files/smb.conf.template
sed -i 's/bind interfaces only = yes/bind interfaces only = no/g' customfeeds/packages/net/samba4/files/smb.conf.template
sed -i 's/#create mask/create mask/g' customfeeds/packages/net/samba4/files/smb.conf.template
sed -i 's/#directory mask/directory mask/g' customfeeds/packages/net/samba4/files/smb.conf.template
sed -i 's/0666/0644/g;s/0744/0755/g;s/0777/0755/g' customfeeds/luci/applications/luci-app-samba4/htdocs/luci-static/resources/view/samba4.js
sed -i 's/0666/0644/g;s/0777/0755/g' customfeeds/packages/net/samba4/files/samba.config
sed -i 's/0666/0644/g;s/0777/0755/g' customfeeds/packages/net/samba4/files/smb.conf.template

# natmap
pushd customfeeds/luci
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/luci/applications/luci-app-natmap/0001-luci-app-natmap-add-default-STUN-server-lists.patch | patch -p1
popd

# Realtek driver - R8168 & R8125 & R8126 & R8152 & R8101
rm -rf package/kernel/r8168 package/kernel/r8152 package/kernel/r8101 package/kernel/r8125 package/kernel/r8126
git clone https://github.com/sbwml/package_kernel_r8168 package/kernel/r8168
git clone https://github.com/sbwml/package_kernel_r8152 package/kernel/r8152
git clone https://github.com/sbwml/package_kernel_r8101 package/kernel/r8101
git clone https://github.com/sbwml/package_kernel_r8125 package/kernel/r8125
git clone https://github.com/sbwml/package_kernel_r8126 package/kernel/r8126

# UPnP
rm -rf customfeeds/{packages/net/miniupnpd,luci/applications/luci-app-upnp}
git clone https://git.cooluc.com/sbwml/miniupnpd customfeeds/packages/net/miniupnpd -b v2.3.7
git clone https://git.cooluc.com/sbwml/luci-app-upnp customfeeds/luci/applications/luci-app-upnp -b main

# procps-ng - top
rm -rf customfeeds/packages/utils/procps-ng
cp -r $GITHUB_WORKSPACE/data/packages-master/utils/procps-ng customfeeds/packages/utils/procps-ng
sed -i 's/enable-skill/enable-skill --disable-modern-top/g' customfeeds/packages/utils/procps-ng/Makefile

# default settings
rm -rf package/emortal/default-settings
git clone https://github.com/sbwml/default-settings package/emortal/default-settings

# pushd customfeeds/packages
# xr_usb_serial_common
# curl -s https://github.com/openwrt/packages/commit/23a3ea2d6b3779cd48d318b95a3c72cad9433d50.patch | patch -p1
# fix linux-6.6
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/xr_usb_serial_common/900-fix-linux-6.6.patch > libs/xr_usb_serial_common/patches/900-fix-linux-6.6.patch
# coova-chilli
# curl -s https://github.com/openwrt/packages/commit/9975e855adcfc24939080a5e0279e0a90553347b.patch | patch -p1
# curl -s https://github.com/openwrt/packages/commit/c0683d3f012096fc7b2fbe8b8dc81ea424945e9b.patch | patch -p1
# popd

# perl
rm -rf customfeeds/packages/lang/perl
pushd customfeeds/packages/lang/
git clone --depth 1 https://github.com/immortalwrt/packages coolsnowwolf_perl && mv -n coolsnowwolf_perl/lang/perl ./ ; rm -rf coolsnowwolf_perl
popd
# sed -i "/Target perl/i\TARGET_CFLAGS_PERL += -Wno-implicit-function-declaration -Wno-int-conversion\n" customfeeds/packages/lang/perl/Makefile
# sed -i '/HOST_BUILD_PARALLEL/aPKG_BUILD_FLAGS:=no-mold' customfeeds/packages/lang/perl/Makefile

# telephony
pushd customfeeds/telephony
rm -rf libs/dahdi-linux
git clone https://github.com/sbwml/feeds_telephony_libs_dahdi-linux libs/dahdi-linux
popd

# linux-firmware: rtw89 / rtl8723d / rtl8821c /i915 firmware
rm -rf package/firmware/linux-firmware
git clone https://github.com/sbwml/package_firmware_linux-firmware package/firmware/linux-firmware

# rtl8812au-ct - fix linux-6.6
rm -rf package/kernel/rtl8812au-ct
git clone https://github.com/sbwml/package_kernel_rtl8812au-ct package/kernel/rtl8812au-ct
# add rtl8812au-ac
git clone https://github.com/sbwml/package_kernel_rtl8812au-ac package/kernel/rtl8812au-ac

# 替换杂项
rm -rf customfeeds/packages/net/{*cgi-io,wsdd2}
rm -rf customfeeds/packages/libs/libsodium
rm -rf customfeeds/luci/contrib/package/lucihttp
pushd customfeeds/packages/net/
git clone --depth 1 https://github.com/immortalwrt/packages immortalwrt_packages && mv -n immortalwrt_packages/net/{*cgi-io,wsdd2} ./ ; rm -rf immortalwrt_packages
popd
pushd customfeeds/packages/libs/
git clone --depth 1 https://github.com/immortalwrt/packages immortalwrt_libsodium && mv -n immortalwrt_libsodium/libs/libsodium ./ ; rm -rf immortalwrt_libsodium
popd
pushd customfeeds/luci/contrib/package/
git clone --depth 1 https://github.com/immortalwrt/luci immortalwrt_lucihttp && mv -n immortalwrt_lucihttp/contrib/package/lucihttp ./ ; rm -rf immortalwrt_lucihttp
popd

# 测试杂项

