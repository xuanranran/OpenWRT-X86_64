#!/bin/bash

######################### temp fix ###########################
# apk-tools
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/apk-tools/9999-hack-for-linux-pre-releases.patch > package/system/apk/patches/9999-hack-for-linux-pre-releases.patch
######################### temp fix ###########################

# libsodium - fix build with lto (GNU BUG - 89147)
sed -i "/CONFIGURE_ARGS/i\TARGET_CFLAGS += -ffat-lto-objects\n" customfeeds/packages/libs/libsodium/Makefile

# grub2 -  disable `gc-sections` flag
sed -i '/PKG_BUILD_FLAGS/ s/$/ no-gc-sections/' package/boot/grub2/Makefile

# haproxy - fix build with quictls
sed -i '/USE_QUIC_OPENSSL_COMPAT/d' customfeeds/packages/net/haproxy/Makefile

# xdp-tools
rm -rf package/network/utils/xdp-tools
git clone https://github.com/sbwml/package_network_utils_xdp-tools package/network/utils/xdp-tools -b openwrt-24.10

# fix gcc14
# iproute2
rm -rf package/network/utils/iproute2
git clone https://github.com/sbwml/package_network_utils_iproute2 package/network/utils/iproute2
# libunwind
rm -rf package/libs/libunwind
git clone https://github.com/sbwml/package_libs_libunwind package/libs/libunwind
# linux-atm
rm -rf package/network/utils/linux-atm
git clone https://github.com/sbwml/package_network_utils_linux-atm package/network/utils/linux-atm
# screen
SCREEN_VERSION=4.9.1
SCREEN_HASH=26cef3e3c42571c0d484ad6faf110c5c15091fbf872b06fa7aa4766c7405ac69
sed -ri "s/(PKG_VERSION:=)[^\"]*/\1$SCREEN_VERSION/;s/(PKG_HASH:=)[^\"]*/\1$SCREEN_HASH/" customfeeds/packages/utils/screen/Makefile
rm -rf customfeeds/packages/utils/screen/patches && mkdir -p customfeeds/packages/utils/screen/patches
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openwrt-6.x/gcc-14/screen/900-fix-implicit-function-declaration.patch > customfeeds/packages/utils/screen/patches/900-fix-implicit-function-declaration.patch
# glibc
# Added the compiler flag -Wno-implicit-function-declaration to suppress
# warnings about implicit function declarations during the build process.
# This change addresses build issues in environments where some functions
# are used without prior declaration.

# fix gcc-15
# Mbedtls
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openwrt-6.x/gcc-15/mbedtls/901-tests-fix-string-initialization-error-on-gcc15.patch > package/libs/mbedtls/patches/901-tests-fix-string-initialization-error-on-gcc15.patch
sed -i '/TARGET_CFLAGS/ s/$/ -Wno-error=unterminated-string-initialization/' package/libs/mbedtls/Makefile
# elfutils
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openwrt-6.x/gcc-15/elfutils/901-backends-fix-string-initialization-error-on-gcc15.patch > package/libs/elfutils/patches/901-backends-fix-string-initialization-error-on-gcc15.patch
# libwebsockets
mkdir -p customfeeds/packages/libs/libwebsockets/patches
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openwrt-6.x/gcc-15/libwebsockets/901-fix-string-initialization-error-on-gcc15.patch > customfeeds/packages/libs/libwebsockets/patches/901-fix-string-initialization-error-on-gcc15.patch
# libxcrypt
mkdir -p customfeeds/packages/libs/libxcrypt/patches
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openwrt-6.x/gcc-15/libxcrypt/901-fix-string-initialization-error-on-gcc15.patch > customfeeds/packages/libs/libxcrypt/patches/901-fix-string-initialization-error-on-gcc15.patch


# ksmbd luci
sed -i 's/0666/0644/g;s/0777/0755/g' customfeeds/luci/applications/luci-app-ksmbd/htdocs/luci-static/resources/view/ksmbd.js

# ksmbd tools
sed -i 's/0666/0644/g;s/0777/0755/g' customfeeds/packages/net/ksmbd-tools/files/ksmbd.config.example
sed -i 's/bind interfaces only = yes/bind interfaces only = no/g' customfeeds/packages/net/ksmbd-tools/files/ksmbd.conf.template

# vim - fix E1187: Failed to source defaults.vim
pushd customfeeds/packages
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/vim/0001-vim-fix-renamed-defaults-config-file.patch | patch -p1
popd

# perf
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openwrt-6.x/musl/990-add-typedefs-for-Elf64_Relr-and-Elf32_Relr.patch > toolchain/musl/patches/990-add-typedefs-for-Elf64_Relr-and-Elf32_Relr.patch
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openwrt-6.x/perf/Makefile.2 > package/devel/perf/Makefile
sed -i 's/no-mold//g' package/devel/perf/Makefile

# kselftests-bpf
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/kselftests-bpf/Makefile > package/devel/kselftests-bpf/Makefile
