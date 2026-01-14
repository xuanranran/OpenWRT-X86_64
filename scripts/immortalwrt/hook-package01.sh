#!/bin/bash
# Set to local prepare

# rtpengine
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/rtpengine/900-fix-linux-6.12-11.5.1.18.patch > customfeeds/telephony/net/rtpengine/patches/900-fix-linux-6.12-11.5.1.18.patch

# quectel-cm
rm -rf customfeeds/packages/net/quectel-cm
git clone https://github.com/xuanranran/quectel-cm customfeeds/packages/net/quectel-cm

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

# del packages
rm -rf customfeeds/packages/net/onionshare-cli
# rm -rf customfeeds/telephony/asterisk