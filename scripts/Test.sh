#!/bin/bash
#=================================================
# File name: lean.sh
# System Required: Linux
# Version: 1.0
# Lisence: MIT
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================
# Clone community packages to package/community

rm -rf package/wwan/driver/quectel_MHI
cp -r $GITHUB_WORKSPACE/data/quectel_MHI package/wwan/driver/quectel_MHI

# rm -rf feeds/packages/lang/golang
# git clone https://github.com/sbwml/packages_lang_golang -b 21.x feeds/packages/lang/golang

mkdir package/community
pushd package/community
rm -rf ../../customfeeds/luci/applications/luci-app-netdata
rm -rf ../../customfeeds/luci/applications/luci-app-kodexplorer
rm -rf ../../customfeeds/luci/applications/luci-app-unblockmusic
rm -rf ../../customfeeds/luci/applications/luci-app-aliyundrive-webdav 
rm -rf ../../customfeeds/packages/multimedia/aliyundrive-webdav
rm -rf ../../customfeeds/luci/themes/luci-theme-argon
rm -rf ../../customfeeds/luci/themes/luci-theme-argon-mod
rm -rf ../../staging_dir

# Add openwrt-packages
git clone --depth=1 https://github.com/xuanranran/openwrt-packages openwrt-packages
git clone --depth=1 https://github.com/xuanranran/rely
rm -rf ./openwrt-packages/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
rm -rf ./openwrt-packages/luci-theme-design/htdocs/luci-static/design/favicon.ico
cp -f $GITHUB_WORKSPACE/data/bg1.jpg openwrt-packages/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/data/favicon.ico openwrt-packages/luci-theme-design/htdocs/luci-static/design/favicon.ico

# 在线用户
chmod 755 openwrt-packages/luci-app-onliner/root/usr/share/onliner/setnlbw.sh
popd

# Mod zzz-default-settings
pushd package/lean/default-settings/files
sed -i '$i uci set nlbwmon.@nlbwmon[0].refresh_interval=1s' zzz-default-settings
sed -i '$i uci commit nlbwmon' zzz-default-settings
sed -i '/http/d' zzz-default-settings
# sed -i '/18.06/d' zzz-default-settings
export orig_version=$(cat "zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
export date_version=$(date -d "$(rdate -n -4 -p ntp.aliyun.com)" +'%Y-%m-%d')
sed -i "s/${orig_version}/${orig_version} (${date_version})/g" zzz-default-settings
popd

# Fix libssh
# pushd feeds/packages/libs
# rm -rf libssh
# git clone --depth 1 https://github.com/openwrt/packages openwrt_packages && mv -n openwrt_packages/libs/libssh ./ ; rm -rf openwrt_packages
# popd

# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# Modify default IP
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate

# TTYD 自动登录
# sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# x86 型号只显示 CPU 型号
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/lean/autocore/files/x86/autocore

# 修改本地时间格式
sed -i 's/os.date()/os.date("%F %T %a")/g' package/lean/autocore/files/*/index.htm

# 修复 hostapd 报错
# cp -f $GITHUB_WORKSPACE/data/011-fix-mbo-modules-build.patch package/network/services/hostapd/patches/011-fix-mbo-modules-build.patch

# Test kernel 5.10
rm -rf target/linux/x86/base-files/etc/board.d/02_network
rm -rf package/base-files/files/etc/banner
# rm -rf package/kernel/linux/modules/netsupport.mk
# rm -rf config/Config-kernel.in
cp -f $GITHUB_WORKSPACE/data/banner package/base-files/files/etc/banner
cp -f $GITHUB_WORKSPACE/data/02_network target/linux/x86/base-files/etc/board.d/02_network
# cp -f $GITHUB_WORKSPACE/data/netsupport.mk package/kernel/linux/modules/netsupport.mk
# cp -f $GITHUB_WORKSPACE/data/Config-kernel.in config/Config-kernel.in
# wget -P package/base-files/files/etc https://raw.githubusercontent.com/DHDAXCW/lede-rockchip/stable/package/base-files/files/etc/banner
# sed -i 's/6.1/5.10/g' target/linux/x86/Makefile
# cp -r ../target/linux/generic/pending-6.1/ ./target/linux/generic/
