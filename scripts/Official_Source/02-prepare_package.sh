#!/bin/bash -e

# golang 1.23
rm -rf customfeeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x customfeeds/packages/lang/golang

# node - prebuilt
rm -rf customfeeds/packages/lang/node
git clone https://github.com/sbwml/feeds_packages_lang_node-prebuilt customfeeds/packages/lang/node

# default settings
git clone https://github.com/xuanranran/default-settings package/new/default-settings

# ddns - fix boot
sed -i '/boot()/,+2d' customfeeds/packages/net/ddns-scripts/files/etc/init.d/ddns

# nlbwmon - disable syslog
sed -i 's/stderr 1/stderr 0/g' customfeeds/packages/net/nlbwmon/files/nlbwmon.init

# pcre - 8.45
mkdir -p package/libs/pcre
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/pcre/Makefile > package/libs/pcre/Makefile
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/pcre/Config.in > package/libs/pcre/Config.in

# lrzsz - 0.12.20
rm -rf customfeeds/packages/utils/lrzsz
git clone https://github.com/sbwml/packages_utils_lrzsz package/new/lrzsz

# irqbalance - openwrt master
# irqbalance: disable build with numa
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/irqbalance/011-meson-numa.patch > customfeeds/packages/utils/irqbalance/patches/011-meson-numa.patch
sed -i '/-Dcapng=disabled/i\\t-Dnuma=disabled \\' customfeeds/packages/utils/irqbalance/Makefile

# frpc
sed -i 's/procd_set_param stdout $stdout/procd_set_param stdout 0/g' customfeeds/packages/net/frp/files/frpc.init
sed -i 's/procd_set_param stderr $stderr/procd_set_param stderr 0/g' customfeeds/packages/net/frp/files/frpc.init
sed -i 's/stdout stderr //g' customfeeds/packages/net/frp/files/frpc.init
sed -i '/stdout:bool/d;/stderr:bool/d' customfeeds/packages/net/frp/files/frpc.init
sed -i '/stdout/d;/stderr/d' customfeeds/packages/net/frp/files/frpc.config
sed -i 's/env conf_inc/env conf_inc enable/g' customfeeds/packages/net/frp/files/frpc.init
sed -i "s/'conf_inc:list(string)'/& \\\\/" customfeeds/packages/net/frp/files/frpc.init
sed -i "/conf_inc:list/a\\\t\t\'enable:bool:0\'" customfeeds/packages/net/frp/files/frpc.init
sed -i '/procd_open_instance/i\\t\[ "$enable" -ne 1 \] \&\& return 1\n' customfeeds/packages/net/frp/files/frpc.init
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/luci/applications/luci-app-frpc/001-luci-app-frpc-hide-token-openwrt-24.10.patch | patch -p1
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/luci/applications/luci-app-frpc/002-luci-app-frpc-add-enable-flag-openwrt-24.10.patch | patch -p1

# natmap
pushd customfeeds/luci
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/luci/applications/luci-app-natmap/0001-luci-app-natmap-add-default-STUN-server-lists.patch | patch -p1
popd

# samba4 - bump version
rm -rf customfeeds/packages/net/samba4
git clone https://github.com/sbwml/feeds_packages_net_samba4 customfeeds/packages/net/samba4
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

# aria2 & ariaNG
rm -rf customfeeds/packages/net/ariang
rm -rf customfeeds/luci/applications/luci-app-aria2
git clone https://github.com/sbwml/ariang-nginx package/new/ariang-nginx
rm -rf customfeeds/packages/net/aria2
git clone https://github.com/sbwml/feeds_packages_net_aria2 -b 22.03 customfeeds/packages/net/aria2

# airconnect
git clone https://github.com/sbwml/luci-app-airconnect package/new/airconnect

# netkit-ftp
git clone https://github.com/sbwml/package_new_ftp package/new/ftp

# nethogs
git clone https://github.com/sbwml/package_new_nethogs package/new/nethogs

# SSRP & Passwall
rm -rf customfeeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}
git clone https://github.com/sbwml/openwrt_helloworld package/new/helloworld -b v5

# alist
rm -rf customfeeds/packages/net/alist customfeeds/luci/applications/luci-app-alist
git clone https://github.com/sbwml/openwrt-alist package/new/alist

# netdata
sed -i 's/syslog/none/g' customfeeds/packages/admin/netdata/files/netdata.conf

# qBittorrent
git clone https://github.com/sbwml/luci-app-qbittorrent package/new/qbittorrent

# unblockneteasemusic
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic package/new/luci-app-unblockneteasemusic
sed -i 's/解除网易云音乐播放限制/网易云音乐解锁/g' package/new/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json

# Theme
git clone --depth 1 https://github.com/sbwml/luci-theme-argon package/new/luci-theme-argon -b openwrt-24.10

# Mosdns
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/new/mosdns

# OpenAppFilter
git clone https://github.com/sbwml/OpenAppFilter --depth=1 package/new/OpenAppFilter

# iperf3
sed -i "s/D_GNU_SOURCE/D_GNU_SOURCE -funroll-loops/g" customfeeds/packages/net/iperf3/Makefile

# nlbwmon
sed -i 's/services/network/g' customfeeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json
sed -i 's/services/network/g' customfeeds/luci/applications/luci-app-nlbwmon/htdocs/luci-static/resources/view/nlbw/config.js

# mentohust
git clone https://github.com/sbwml/luci-app-mentohust package/new/mentohust

# custom packages
rm -rf customfeeds/packages/utils/coremark customfeeds/luci/applications/luci-app-filebrowser
git clone https://github.com/sbwml/openwrt_pkgs package/new/custom --depth=1

# luci-compat - fix translation
sed -i 's/<%:Up%>/<%:Move up%>/g' customfeeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm
sed -i 's/<%:Down%>/<%:Move down%>/g' customfeeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm

# frpc translation
sed -i 's,发送,Transmission,g' customfeeds/luci/applications/luci-app-transmission/po/zh_Hans/transmission.po
sed -i 's,frp 服务器,FRP 服务器,g' customfeeds/luci/applications/luci-app-frps/po/zh_Hans/frps.po
sed -i 's,frp 客户端,FRP 客户端,g' customfeeds/luci/applications/luci-app-frpc/po/zh_Hans/frpc.po

# SQM Translation
mkdir -p customfeeds/packages/net/sqm-scripts/patches
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/sqm/001-help-translation.patch > customfeeds/packages/net/sqm-scripts/patches/001-help-translation.patch

# unzip
rm -rf customfeeds/packages/utils/unzip
git clone https://github.com/sbwml/feeds_packages_utils_unzip customfeeds/packages/utils/unzip

# tcp-brutal
git clone https://github.com/sbwml/package_kernel_tcp-brutal package/kernel/tcp-brutal

# watchcat - clean config
true > customfeeds/packages/utils/watchcat/files/watchcat.config
