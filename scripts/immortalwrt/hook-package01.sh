#!/bin/bash
# Set to local prepare

# rtpengine
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/rtpengine/900-fix-linux-6.12-11.5.1.18.patch > customfeeds/telephony/net/rtpengine/patches/900-fix-linux-6.12-11.5.1.18.patch

# fix gcc-15.0.1 gnu17

# xl2tpd
sed -i '/ifneq (0,0)/i TARGET_CFLAGS += -std=gnu17\n' customfeeds/packages/net/xl2tpd/Makefile
# netdata
sed -i '/TARGET_CFLAGS/i TARGET_CFLAGS += -std=gnu17\n' customfeeds/packages/admin/netdata/Makefile

# del packages
# rm -rf customfeeds/packages/net/onionshare-cli