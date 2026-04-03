#!/bin/bash
# Set to local prepare

mirror="https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master"
github="github.com"
gitea="git.cooluc.com"

# autocore
rm -rf package/emortal/autocore
git clone https://github.com/xuanranran/autocore-arm -b openwrt-25.12 package/emortal/autocore

# default settings
rm -rf package/emortal/default-settings
git clone https://github.com/xuanranran/default-settings -b openwrt-25.12 package/emortal/default-settings

# custom packages
rm -rf customfeeds/luci/applications/{luci-app-filebrowser,luci-app-argon-config}
rm -rf customfeeds/luci/themes/luci-theme-argon
rm -rf customfeeds/packages/net/shadowsocks-libev

rm -rf customfeeds/packages/net/{*alist,chinadns-ng,dns2socks,dns2tcp,lucky,sing-box}

# Update golang
rm -rf customfeeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang customfeeds/packages/lang/golang

# samba4 - bump version
# rm -rf customfeeds/packages/net/samba4
# git clone https://github.com/sbwml/feeds_packages_net_samba4 customfeeds/packages/net/samba4
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

# xdp-tools
rm -rf package/network/utils/xdp-tools
git clone --depth 1 https://github.com/sbwml/package_network_utils_xdp-tools package/network/utils/xdp-tools

# clang
# xtables-addons module
rm -rf customfeeds/packages/net/xtables-addons
git clone https://$github/sbwml/kmod_packages_net_xtables-addons customfeeds/packages/net/xtables-addons -b openwrt-25.12
# netatop
sed -i 's/$(MAKE)/$(KERNEL_MAKE)/g' customfeeds/packages/admin/netatop/Makefile
curl -s $mirror/openwrt/patch/packages-patches/clang/netatop/900-fix-build-with-clang.patch > customfeeds/packages/admin/netatop/patches/900-fix-build-with-clang.patch
# dmx_usb_module
rm -rf customfeeds/packages/libs/dmx_usb_module
git clone https://git.cooluc.com/sbwml/feeds_packages_libs_dmx_usb_module customfeeds/packages/libs/dmx_usb_module
# macremapper
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/6.6/openwrt/patch/packages-patches/clang/macremapper/100-macremapper-fix-clang-build.patch | patch -p1
# coova-chilli module
rm -rf customfeeds/packages/net/coova-chilli
git clone https://$github/sbwml/kmod_packages_net_coova-chilli customfeeds/packages/net/coova-chilli

# nat46
mkdir -p package/kernel/nat46/patches
curl -s $mirror/openwrt/patch/packages-patches/nat46/102-fix-build-with-kernel-6.18.patch > package/kernel/nat46/patches/102-fix-build-with-kernel-6.18.patch

# openvswitch
sed -i '/ovs_kmod_openvswitch_depends/a\\t\ \ +kmod-sched-act-sample \\' customfeeds/packages/net/openvswitch/Makefile

# rtpengine
curl -s $mirror/openwrt/patch/packages-patches/rtpengine/901-fix-build-for-linux-6.18.patch > customfeeds/telephony/net/rtpengine/patches/901-fix-build-for-linux-6.18.patch

# usb-serial-xr_usb_serial_common: remove package
# Now that we have packaged the upstream driver[1] and only board[2] that
# includes it by default has been switched to it, remove this out-of-tree
# driver that is broken on 6.12 anyway.
rm -rf customfeeds/packages/libs/xr_usb_serial_common

# v4l2loopback
rm -rf customfeeds/packages/kernel/v4l2loopback
mkdir -p customfeeds/packages/kernel/v4l2loopback
curl -s $mirror/openwrt/patch/packages-patches/v4l2loopback/Makefile > customfeeds/packages/kernel/v4l2loopback/Makefile

# telephony
pushd customfeeds/telephony
  # dahdi-linux
  rm -rf libs/dahdi-linux
  git clone https://$github/sbwml/feeds_telephony_libs_dahdi-linux libs/dahdi-linux -b v6.18
popd

# boots
sed -i 's|^PKG_SOURCE_URL:=.*|PKG_SOURCE_URL:=@SF/$(PKG_NAME)/$(PKG_NAME)/$(PKG_VERSION)|g' customfeeds/packages/libs/boost/Makefile

# fix gcc-15.0.1 gnu17

# xl2tpd
sed -i '/ifneq (0,0)/i TARGET_CFLAGS += -std=gnu17\n' customfeeds/packages/net/xl2tpd/Makefile
# netdata
sed -i '/TARGET_CFLAGS/i TARGET_CFLAGS += -std=gnu17\n' customfeeds/packages/admin/netdata/Makefile
# uwsgi
sed -i '/MAKE_VARS/i TARGET_CFLAGS += -std=gnu17\n' customfeeds/packages/net/uwsgi/Makefile
# libpam
sed -i '/MESON_ARGS/i TARGET_CFLAGS += -std=gnu17\n' customfeeds/packages/libs/libpam/Makefile
# coova-chilli - fix gcc 15 c23
sed -i '/TARGET_CFLAGS/s/$/ -std=gnu17/' customfeeds/packages/net/coova-chilli/Makefile

sed -i '/^CONFIG_FAILOVER=y$/a # CONFIG_SHORTCUT_FE is not set' target/linux/x86/64/config-6.18

# libnftnl
rm -rf package/libs/libnftnl/patches
# nftables
rm -rf package/network/utils/nftables/patches

# del packages
rm -rf customfeeds/packages/net/onionshare-cli
rm -rf customfeeds/packages/net/fail2ban
rm -rf customfeeds/packages/utils/setools
