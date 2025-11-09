#!/bin/bash
# Set to local prepare

# rtpengine
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/rtpengine/900-fix-linux-6.12-11.5.1.18.patch > customfeeds/telephony/net/rtpengine/patches/900-fix-linux-6.12-11.5.1.18.patch

# routing - batman-adv fix build with linux-6.12
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/batman-adv/901-fix-linux-6.12rc2-builds.patch > customfeeds/routing/batman-adv/patches/901-fix-linux-6.12rc2-builds.patch

# libxcrypt
sed -i "/CONFIGURE_ARGS/i\TARGET_CFLAGS += -Wno-error=pedantic\n" package/libs/xcrypt/libxcrypt/Makefile

# protobuf
curl -s https://raw.githubusercontent.com/openwrt/packages/refs/heads/master/libs/protobuf/Makefile > customfeeds/packages/libs/protobuf/Makefile
curl -s https://raw.githubusercontent.com/openwrt/packages/refs/heads/master/libs/protobuf/patches/001-cmake4.patch > customfeeds/packages/libs/protobuf/patches/001-cmake4.patch

# qrencode
curl -s https://raw.githubusercontent.com/openwrt/packages/refs/heads/master/ibs/qrencode/Makefile > customfeeds/packages/ibs/qrencode/Makefile
curl -s https://raw.githubusercontent.com/openwrt/packages/refs/heads/master/libs/qrencode/patches/001-cmake-version.patch > customfeeds/packages/libs/qrencode/patches/001-cmake-version.patch
