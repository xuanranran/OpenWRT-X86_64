#!/bin/bash
# Set to local prepare

# rtpengine
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/rtpengine/900-fix-linux-6.12-11.5.1.18.patch > customfeeds/telephony/net/rtpengine/patches/900-fix-linux-6.12-11.5.1.18.patch

# routing - batman-adv fix build with linux-6.12
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/batman-adv/901-fix-linux-6.12rc2-builds.patch > customfeeds/routing/batman-adv/patches/901-fix-linux-6.12rc2-builds.patch

# libxcrypt
sed -i "/CONFIGURE_ARGS/i\TARGET_CFLAGS += -Wno-error=pedantic\n" package/libs/xcrypt/libxcrypt/Makefile

rm -rf target/linux/generic/backport-6.12/404-v6.19-mtd-spinand-fmsh-remove-QE-bit-for-FM25S01A-flash.patch