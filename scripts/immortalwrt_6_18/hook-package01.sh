#!/bin/bash
# Set to local prepare

mirror="https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master"
github="github.com"
gitea="git.cooluc.com"

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

# del packages
rm -rf customfeeds/packages/net/onionshare-cli
# rm -rf customfeeds/telephony/asterisk