#!/bin/bash
# Set to local prepare

# cryptodev-linux
mkdir -p package/kernel/cryptodev-linux/patches
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/cryptodev-linux/6.12/0005-Fix-cryptodev_verbosity-sysctl-for-Linux-6.11-rc1.patch > package/kernel/cryptodev-linux/patches/0005-Fix-cryptodev_verbosity-sysctl-for-Linux-6.11-rc1.patch
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/cryptodev-linux/6.12/0006-Exclude-unused-struct-since-Linux-6.5.patch > package/kernel/cryptodev-linux/patches/0006-Exclude-unused-struct-since-Linux-6.5.patch

# jool
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/jool/Makefile > customfeeds/packages/net/jool/Makefile

# ovpn-dco
mkdir -p customfeeds/packages/kernel/ovpn-dco/patches
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/ovpn-dco/901-fix-linux-6.11.patch > customfeeds/packages/kernel/ovpn-dco/patches/901-fix-linux-6.11.patch
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/ovpn-dco/902-fix-linux-6.12.patch > customfeeds/packages/kernel/ovpn-dco/patches/902-fix-linux-6.12.patch

# libpfring
rm -rf customfeeds/packages/libs/libpfring
mkdir -p customfeeds/packages/libs/libpfring/patches
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/libpfring/Makefile > customfeeds/packages/libs/libpfring/Makefile
pushd customfeeds/packages/libs/libpfring/patches
  curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/libpfring/patches/0001-fix-cross-compiling.patch
  curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/libpfring/patches/100-fix-compilation-warning.patch
  curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/libpfring/patches/900-fix-linux-6.6.patch
popd

# openvswitch
sed -i '/ovs_kmod_openvswitch_depends/a\\t\ \ +kmod-sched-act-sample \\' customfeeds/packages/net/openvswitch/Makefile

# rtpengine
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/rtpengine/900-fix-linux-6.12-11.5.1.18.patch > customfeeds/telephony/net/rtpengine/patches/900-fix-linux-6.12-11.5.1.18.patch

# ubootenv-nvram - 6.12
mkdir -p package/kernel/ubootenv-nvram/patches
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/ubootenv-nvram/010-make-ubootenv_remove-return-void-for-linux-6.12.patch > package/kernel/ubootenv-nvram/patches/010-make-ubootenv_remove-return-void-for-linux-6.12.patch

# packages
pushd customfeeds/packages
  # xr_usb_serial_common linux-6.12
  curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/xr_usb_serial_common/0002-fix-kernel-6.12-builds.patch > libs/xr_usb_serial_common/patches/0002-fix-kernel-6.12-builds.patch
popd

# routing - batman-adv fix build with linux-6.12
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/batman-adv/901-fix-linux-6.12rc2-builds.patch > customfeeds/routing/batman-adv/patches/901-fix-linux-6.12rc2-builds.patch

# libsodium - fix build with lto (GNU BUG - 89147)
sed -i "/CONFIGURE_ARGS/i\TARGET_CFLAGS += -ffat-lto-objects\n" customfeeds/packages/libs/libsodium/Makefile

# kselftests-bpf
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/kselftests-bpf/Makefile > package/devel/kselftests-bpf/Makefile

# sms-tools
mkdir -p customfeeds/packages/utils/sms-tool/patches
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/sms-tools/900-fix-incompatible-pointer-type-error-for-signal-function.patch > customfeeds/packages/utils/sms-tool/patches/900-fix-incompatible-pointer-type-error-for-signal-function.patch

# bcm53xx
# libpfring
sed -i '/CONFIGURE_VARS +=/iEXTRA_CFLAGS += -Wno-int-conversion\n' customfeeds/packages/libs/libpfring/Makefile

# bcm53xx
# mtd
sed -i 's/=1 -Wall/=1 -Wall -Wno-implicit-function-declaration/g' package/system/mtd/Makefile
# uwsgi
sed -i '/MAKE_VARS+=/iTARGET_CFLAGS += -Wno-incompatible-pointer-types\n' customfeeds/packages/net/uwsgi/Makefile
# libsoxr
sed -i '/CMAKE_INSTALL/iPKG_BUILD_FLAGS:=no-lto no-mold\n' customfeeds/packages/libs/libsoxr/Makefile
# wsdd2
sed -i '/Build\/Compile/iTARGET_CFLAGS += -Wno-error -Wno-int-conversion\n' customfeeds/packages/net/wsdd2/Makefile

# glibc
sed -i '/NaiveProxy/d' .config

# IF USE GLIBC
# musl-libc
git clone https://git.cooluc.com/sbwml/package_libs_musl-libc package/libs/musl-libc
# glibc-common
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/glibc/glibc-common.patch | patch -p1
# glibc-common - locale data
mkdir -p package/libs/toolchain/glibc-locale
curl -Lso package/libs/toolchain/glibc-locale/locale-archive https://github.com/sbwml/r4s_build_script/releases/download/locale/locale-archive
# GNU LANG
mkdir package/base-files/files/etc/profile.d
echo 'export LANG="en_US.UTF-8" I18NPATH="/usr/share/i18n"' > package/base-files/files/etc/profile.d/sys_locale.sh
# build - drop `--disable-profile`
sed -i "/disable-profile/d" toolchain/glibc/common.mk
