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

#rm -rf package/libs/libnl-tiny
#rm -rf package/kernel/mac80211
#rm -rf package/kernel/mt76
#rm -rf package/network/services/hostapd
#rm -rf package/wwan
#svn export https://github.com/DHDAXCW/lede-rockchip/trunk/package/wwan package/wwan
#svn export https://github.com/openwrt/openwrt/trunk/package/libs/libnl-tiny package/libs/libnl-tiny
#svn export https://github.com/openwrt/openwrt/trunk/package/kernel/mac80211 package/kernel/mac80211
#svn export https://github.com/DHDAXCW/lede-rockchip/trunk/package/kernel/mt76 package/kernel/mt76
#svn export https://github.com/openwrt/openwrt/trunk/package/network/services/hostapd package/network/services/hostapd

# alist
svn export https://github.com/sbwml/luci-app-alist/trunk/luci-app-alist package/luci-app-alist
svn export https://github.com/sbwml/luci-app-alist/trunk/alist package/alist
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 21.x feeds/packages/lang/golang

mkdir package/community
pushd package/community

# netdata
rm -rf feeds/luci/applications/luci-app-netdata
git clone --depth=1 https://github.com/Jason6111/luci-app-netdata package/luci-app-netdata

# Add Lienol's Packages
git clone --depth=1 https://github.com/Lienol/openwrt-package
rm -rf ../../customfeeds/luci/applications/luci-app-kodexplorer
rm -rf openwrt-package/verysync
rm -rf openwrt-package/luci-app-verysync

# Add luci-app-ssr-plus
rm -rf package/community/helloworld
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages

# Add luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2
svn export https://github.com/xiaorouji/openwrt-passwall/trunk/luci-app-passwall
svn export https://github.com/xiaorouji/openwrt-passwall2/trunk/luci-app-passwall2

# Add luci-app-unblockneteasemusic
rm -rf ../../customfeeds/luci/applications/luci-app-unblockmusic
git clone --depth=1 https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git

# Add luci-app-vssr <M>
git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb.git
git clone --depth=1 https://github.com/jerrykuku/luci-app-vssr

# Add luci-proto-minieap
git clone --depth=1 https://github.com/ysc3839/luci-proto-minieap

# Add luci-app-onliner (need luci-app-nlbwmon)
# git clone --depth=1 https://github.com/rufengsuixing/luci-app-onliner

# Add ddnsto & linkease
svn export https://github.com/linkease/nas-packages-luci/trunk/luci/luci-app-ddnsto
svn export https://github.com/linkease/nas-packages/trunk/network/services/ddnsto

# Add OpenClash
svn export https://github.com/vernesong/OpenClash/trunk/luci-app-openclash

# Add luci-app-poweroff
git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff

# Add iStore
svn export https://github.com/linkease/istore-ui/trunk/app-store-ui package/app-store-ui
svn export https://github.com/linkease/istore/trunk/luci package/luci-app-store

# Add luci-theme
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config
rm -rf ../../customfeeds/luci/themes/luci-theme-argon
rm -rf ../../customfeeds/luci/themes/luci-theme-argon-mod
rm -rf ./luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/data/bg1.jpg luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
git clone https://github.com/DHDAXCW/theme

# Add subconverter
git clone --depth=1 https://github.com/tindy2013/openwrt-subconverter

# Add luci-app-mosdns
# svn export https://github.com/281677160/openwrt-package/trunk/luci-app-mosdns

# Add apk (Apk Packages Manager)
svn export https://github.com/openwrt/packages/trunk/utils/apk

# Add OpenAppFilter
git clone --depth=1 https://github.com/destan19/OpenAppFilter

# Add luci-aliyundrive-webdav
rm -rf ../../customfeeds/luci/applications/luci-app-aliyundrive-webdav 
rm -rf ../../customfeeds/packages/multimedia/aliyundrive-webdav
svn export https://github.com/messense/aliyundrive-webdav/trunk/openwrt/aliyundrive-webdav
svn export https://github.com/messense/aliyundrive-webdav/trunk/openwrt/luci-app-aliyundrive-webdav
popd

# Add linkease/openwrt-app-actions
# svn export https://github.com/linkease/openwrt-app-actions/trunk/applications --force package/community/

# Add Pandownload
pushd package/lean
svn export https://github.com/immortalwrt/packages/trunk/net/pandownload-fake-server
popd

# 在线用户
svn export https://github.com/haiibo/packages/trunk/luci-app-onliner package/luci-app-onliner
sed -i '$i uci set nlbwmon.@nlbwmon[0].refresh_interval=1s' package/lean/default-settings/files/zzz-default-settings
sed -i '$i uci commit nlbwmon' package/lean/default-settings/files/zzz-default-settings
chmod 755 package/luci-app-onliner/root/usr/share/onliner/setnlbw.sh

# Mod zzz-default-settings
pushd package/lean/default-settings/files
sed -i '/http/d' zzz-default-settings
sed -i '/18.06/d' zzz-default-settings
export orig_version=$(cat "zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
export date_version=$(date -d "$(rdate -n -4 -p ntp.aliyun.com)" +'%Y-%m-%d')
sed -i "s/${orig_version}/${orig_version} (${date_version})/g" zzz-default-settings
popd

# Fix libssh
pushd feeds/packages/libs
rm -rf libssh
svn export https://github.com/openwrt/packages/trunk/libs/libssh
popd

# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# Modify default IP
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate

# TTYD 自动登录
# sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# x86 型号只显示 CPU 型号
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/lean/autocore/files/x86/autocore

# 修改本地时间格式
# sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm
sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm

# 修改版本为编译日期
# date_version=$(date +"%y.%m.%d")
# orig_version=$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
# sed -i "s/${orig_version}/R${date_version} by LovinYarn/g" package/lean/default-settings/files/zzz-default-settings

# 修复 hostapd 报错
cp -f $GITHUB_WORKSPACE/scripts/011-fix-mbo-modules-build.patch package/network/services/hostapd/patches/011-fix-mbo-modules-build.patch

# Test kernel 5.10
rm -rf target/linux/x86/base-files/etc/board.d/02_network
cp -f $GITHUB_WORKSPACE/02_network target/linux/x86/base-files/etc/board.d/02_network
rm -rf package/base-files/files/etc/banner
wget -P package/base-files/files/etc https://raw.githubusercontent.com/DHDAXCW/lede-rockchip/stable/package/base-files/files/etc/banner
# sed -i 's/6.1/5.10/g' target/linux/x86/Makefile
cp -r ../target/linux/generic/pending-6.1/ ./target/linux/generic/
