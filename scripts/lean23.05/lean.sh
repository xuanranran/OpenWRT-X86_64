#!/bin/bash
#=================================================
# File name: lean_6_6.sh
# System Required: Linux
# Version: 1.0
# Lisence: MIT
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================
# Clone community packages to package/community
mkdir package/community
pushd package/community
rm -rf ../../customfeeds/luci/applications/luci-app-netdata
rm -rf ../../customfeeds/luci/applications/luci-app-kodexplorer
rm -rf ../../customfeeds/luci/applications/luci-app-unblockmusic
rm -rf ../../customfeeds/luci/applications/luci-app-aliyundrive-webdav 
rm -rf ../../customfeeds/luci/themes/luci-theme-argon
rm -rf ../../customfeeds/luci/themes/luci-theme-argon-mod
rm -rf ../../customfeeds/luci/themes/luci-theme-design
rm -rf ../../customfeeds/packages/utils/apk
rm -rf ../../customfeeds/packages/multimedia/aliyundrive-webdav

# Add openwrt-packages
git clone --depth=1 https://github.com/xuanranran/openwrt-package openwrt-package
git clone --depth=1 https://github.com/xuanranran/rely openwrt-rely
chmod 755 openwrt-package/luci-app-onliner/root/usr/share/onliner/setnlbw.sh
popd

# Mod zzz-default-settings
pushd package/lean/default-settings/files
sed -i '$i uci set nlbwmon.@nlbwmon[0].refresh_interval=1s' zzz-default-settings
sed -i '$i uci commit nlbwmon' zzz-default-settings
sed -i '/http/d' zzz-default-settings
sed -i '/23.05/d' zzz-default-settings
export orig_version=$(cat "zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
export date_version=$(date -d "$(rdate -n -4 -p ntp.aliyun.com)" +'%Y-%m-%d')
sed -i "s/${orig_version}/${orig_version} (${date_version})/g" zzz-default-settings
popd

sed -i 's/boardinfo.release.description +/boardinfo.release.description + boardinfo.release.revision +/g' customfeeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js

# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# Modify default IP
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/luci2/bin/config_generate

# x86 型号只显示 CPU 型号
# sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/lean/autocore/files/x86/autocore

# 修改Makefile 禁用iperf3-ssl
sed -i 's/iperf3-ssl[[:space:]]*//g' target/linux/x86/Makefile

# 修改开源站地址
sed -i 's/mirror.iscas.ac.cn/mirrors.mit.edu/g' scripts/download.pl
sed -i 's/mirrors.aliyun.com/mirror.netcologne.de/g' scripts/download.pl
# sed -i '/mirror2.openwrt.org/a\push @mirrors, '\''https://source.cooluc.com'\'';' scripts/download.pl

# sed -i 's/+firewall/+uci-firewall/g' customfeeds/luci/applications/luci-app-firewall/Makefile

rm -rf target/linux/x86/base-files/etc/board.d/02_network
rm -rf package/base-files/files/etc/banner
cp -f $GITHUB_WORKSPACE/data/banner package/base-files/files/etc/banner
cp -f $GITHUB_WORKSPACE/data/02_network target/linux/x86/base-files/etc/board.d/02_network

# Test kernel 6.12
sed -i 's/6.6/6.12/g' target/linux/x86/Makefile
