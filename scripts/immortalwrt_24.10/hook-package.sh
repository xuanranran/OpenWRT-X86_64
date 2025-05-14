#!/bin/bash
# Set to local prepare

# autocore
rm -rf package/emortal/autocore
git clone https://github.com/xuanranran/autocore-arm -b openwrt-24.10 package/emortal/autocore

# default settings
rm -rf package/emortal/default-settings
git clone https://github.com/xuanranran/default-settings package/emortal/default-settings

# custom packages
rm -rf customfeeds/luci/applications/{luci-app-filebrowser,luci-app-argon-config}
rm -rf customfeeds/luci/themes/luci-theme-argon
rm -rf customfeeds/packages/net/shadowsocks-libev

rm -rf customfeeds/packages/net/{*alist,chinadns-ng,dns2socks,dns2tcp,lucky,sing-box}
# chmod 755 customfeeds/lovepackages/luci-app-onliner/root/usr/share/onliner/setnlbw.sh

# sed -i 's/1.14.1/1.14.2/g' customfeeds/packages/net/zerotier/Makefile
# sed -i 's/4f9f40b27c5a78389ed3f3216c850921f6298749e5819e9f2edabb2672ce9ca0/c2f64339fccf5148a7af089b896678d655fbfccac52ddce7714314a59d7bddbb/g' customfeeds/packages/net/zerotier/Makefile

# apk-tools
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/apk-tools/9999-hack-for-linux-pre-releases.patch > package/system/apk/patches/9999-hack-for-linux-pre-releases.patch

# Update golang 1.23.x
rm -rf customfeeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang customfeeds/packages/lang/golang
# git clone https://github.com/sbwml/packages_lang_golang -b 23.x customfeeds/packages/lang/golang


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

# Realtek driver - R8168 & R8125 & R8126 & R8152 & R8101 & r8127
# rm -rf package/kernel/{r8168,r8101,r8125,r8126,r8127,r8152}
# git clone https://github.com/sbwml/package_kernel_r8168 package/kernel/r8168
# git clone https://github.com/sbwml/package_kernel_r8152 package/kernel/r8152
# git clone https://github.com/sbwml/package_kernel_r8101 package/kernel/r8101
# git clone https://github.com/sbwml/package_kernel_r8125 package/kernel/r8125
# git clone https://github.com/sbwml/package_kernel_r8126 package/kernel/r8126
# git clone https://github.com/sbwml/package_kernel_r8127 package/kernel/r8127

# procps-ng - top
sed -i 's/enable-skill/enable-skill --disable-modern-top/g' customfeeds/packages/utils/procps-ng/Makefile

# xdp-tools
rm -rf package/network/utils/xdp-tools
git clone https://github.com/sbwml/package_network_utils_xdp-tools package/network/utils/xdp-tools


# 测试杂项

