#!/bin/bash -e

######## OpenWrt Patches ########

[ "$version" = "rc2" ] && generic=generic || generic=generic-24.10

# tools: add llvm/clang toolchain
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0001-tools-add-llvm-clang-toolchain.patch | patch -p1

# tools: add upx tools
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0002-tools-add-upx-tools.patch | patch -p1

# rootfs: upx compression
# include/rootfs.mk
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0003-rootfs-add-upx-compression-support.patch | patch -p1

# rootfs: add r/w (0600) permissions for UCI configuration files
# include/rootfs.mk
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0004-rootfs-add-r-w-permissions-for-UCI-configuration-fil.patch | patch -p1

# rootfs: Add support for local kmod installation sources
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0005-rootfs-Add-support-for-local-kmod-installation-sourc.patch | patch -p1

# BTF: fix failed to validate module
# config/Config-kernel.in patch
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0006-kernel-add-MODULE_ALLOW_BTF_MISMATCH-option.patch | patch -p1

# kernel: Add support for llvm/clang compiler
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0007-kernel-Add-support-for-llvm-clang-compiler.patch | patch -p1

# toolchain: Add libquadmath to the toolchain
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0008-libquadmath-Add-libquadmath-to-the-toolchain.patch | patch -p1

# build: kernel: add out-of-tree kernel config
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0009-build-kernel-add-out-of-tree-kernel-config.patch | patch -p1

# kernel: linux-6.11 config
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0010-include-kernel-add-miss-config-for-linux-6.11.patch | patch -p1

# meson: add platform variable to cross-compilation file
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0011-meson-add-platform-variable-to-cross-compilation-fil.patch | patch -p1

# kernel 6.12: add legacy cgroup v1 memory controller
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0012-kernel-add-legacy-cgroup-v1-memory-controller.patch | patch -p1
# kernel 6.12: add linux-rt support for aarch64/x86_64
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0013-kernel-add-PREEMPT_RT-support-for-aarch64-x86_64.patch | patch -p1

# mold
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/203-tools-mold-update-to-2.34.1.patch | patch -p1

# attr no-mold
sed -i '/PKG_BUILD_PARALLEL/aPKG_BUILD_FLAGS:=no-mold' customfeeds/packages/utils/attr/Makefile

######## OpenWrt Patches End ########

# dwarves 1.25
rm -rf tools/dwarves
git clone https://github.com/sbwml/tools_dwarves tools/dwarves

# x86 - disable intel_pstate & mitigations
sed -i 's/noinitrd/noinitrd intel_pstate=disable mitigations=off/g' target/linux/x86/image/grub-efi.cfg

# Use nginx instead of uhttpd
# if [ "$ENABLE_UHTTPD" != "y" ]; then
    # sed -i 's/+uhttpd /+luci-nginx /g' customfeeds/luci/collections/luci/Makefile
    # sed -i 's/+uhttpd-mod-ubus //' customfeeds/luci/collections/luci/Makefile
    # sed -i 's/+uhttpd /+luci-nginx /g' customfeeds/luci/collections/luci-light/Makefile
    # sed -i "s/+luci /+luci-nginx /g" customfeeds/luci/collections/luci-ssl-openssl/Makefile
    # sed -i "s/+luci /+luci-nginx /g" customfeeds/luci/collections/luci-ssl/Makefile
    # if [ "$version" = "snapshots-24.10" ] || [ "$version" = "rc2" ]; then
        # sed -i 's/+uhttpd +uhttpd-mod-ubus /+luci-nginx /g' customfeeds/packages/net/wg-installer/Makefile
        # sed -i '/uhttpd-mod-ubus/d' customfeeds/luci/collections/luci-light/Makefile
        # sed -i 's/+luci-nginx \\$/+luci-nginx/' customfeeds/luci/collections/luci-light/Makefile
    # fi
# fi

# Realtek driver - R8168 & R8125 & R8126 & R8152 & R8101
rm -rf package/kernel/r8168 package/kernel/r8101 package/kernel/r8125 package/kernel/r8125 package/kernel/r8126
git clone https://github.com/sbwml/package_kernel_r8168 package/kernel/r8168
git clone https://github.com/sbwml/package_kernel_r8152 package/kernel/r8152
git clone https://github.com/sbwml/package_kernel_r8101 package/kernel/r8101
git clone https://github.com/sbwml/package_kernel_r8125 package/kernel/r8125
git clone https://github.com/sbwml/package_kernel_r8126 package/kernel/r8126

# GCC Optimization level -O3
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/target-modify_for_x86_64.patch | patch -p1

# DPDK & NUMACTL
mkdir -p package/new/{dpdk/patches,numactl}
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/dpdk/dpdk/Makefile > package/new/dpdk/Makefile
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/dpdk/dpdk/Config.in > package/new/dpdk/Config.in
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/dpdk/dpdk/patches/010-dpdk_arm_build_platform_fix.patch > package/new/dpdk/patches/010-dpdk_arm_build_platform_fix.patch
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/dpdk/dpdk/patches/201-r8125-add-r8125-ethernet-poll-mode-driver.patch > package/new/dpdk/patches/201-r8125-add-r8125-ethernet-poll-mode-driver.patch
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/dpdk/numactl/Makefile > package/new/numactl/Makefile

# Mbedtls AES & GCM Crypto Extensions
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/mbedtls-23.05/200-Implements-AES-and-GCM-with-ARMv8-Crypto-Extensions.patch > package/libs/mbedtls/patches/200-Implements-AES-and-GCM-with-ARMv8-Crypto-Extensions.patch
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/mbedtls-23.05/mbedtls.patch | patch -p1

# fstools
rm -rf package/system/fstools
git clone https://github.com/sbwml/package_system_fstools -b openwrt-24.10 package/system/fstools
# util-linux
rm -rf package/utils/util-linux
git clone https://github.com/sbwml/package_utils_util-linux -b openwrt-24.10 package/utils/util-linux

# Shortcut Forwarding Engine
git clone https://git.cooluc.com/sbwml/shortcut-fe package/new/shortcut-fe

# dnsmasq
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/dnsmasq/0001-dnsmasq-drop-extraconftext-parameter.patch | patch -p1
curl -s https://init2.cooluc.com/openwrt/patch/dnsmasq/dnsmasq.init > package/network/services/dnsmasq/files/dnsmasq.init

# Patch FireWall 4
# firewall4 - master
sed -i 's|$(PROJECT_GIT)/project|https://github.com/openwrt|g' package/network/config/firewall4/Makefile
mkdir -p package/network/config/firewall4/patches
# fix ct status dnat
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/firewall4_patches/990-unconditionally-allow-ct-status-dnat.patch > package/network/config/firewall4/patches/990-unconditionally-allow-ct-status-dnat.patch
# fullcone
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/firewall4_patches/999-01-firewall4-add-fullcone-support.patch > package/network/config/firewall4/patches/999-01-firewall4-add-fullcone-support.patch
# bcm fullcone
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/firewall4_patches/999-02-firewall4-add-bcm-fullconenat-support.patch > package/network/config/firewall4/patches/999-02-firewall4-add-bcm-fullconenat-support.patch
# kernel version
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/firewall4_patches/002-fix-fw4.uc-adept-kernel-version-type-of-x.x.patch > package/network/config/firewall4/patches/002-fix-fw4.uc-adept-kernel-version-type-of-x.x.patch
# fix flow offload
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/firewall4_patches/001-fix-fw4-flow-offload.patch > package/network/config/firewall4/patches/001-fix-fw4-flow-offload.patch
# add custom nft command support
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/100-openwrt-firewall4-add-custom-nft-command-support.patch | patch -p1
# libnftnl
rm -rf package/libs/libnftnl
mkdir -p package/libs/libnftnl/patches
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/libnftnl/Makefile > package/libs/libnftnl/Makefile
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/libnftnl/0001-libnftnl-add-fullcone-expression-support.patch > package/libs/libnftnl/patches/0001-libnftnl-add-fullcone-expression-support.patch
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/libnftnl/0002-libnftnl-add-brcm-fullcone-support.patch > package/libs/libnftnl/patches/0002-libnftnl-add-brcm-fullcone-support.patch
# nftables
rm -rf package/network/utils/nftables
mkdir -p package/network/utils/nftables/patches
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/nftables/Makefile > package/network/utils/nftables/Makefile
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/nftables/0001-nftables-add-fullcone-expression-support.patch > package/network/utils/nftables/patches/0001-nftables-add-fullcone-expression-support.patch
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/nftables/0002-nftables-add-brcm-fullconenat-support.patch > package/network/utils/nftables/patches/0002-nftables-add-brcm-fullconenat-support.patch


# FullCone module
git clone https://git.cooluc.com/sbwml/nft-fullcone package/new/nft-fullcone

# IPv6 NAT
git clone https://github.com/sbwml/packages_new_nat6 package/new/nat6

# natflow
git clone https://github.com/sbwml/package_new_natflow package/new/natflow

# Patch Luci add nft_fullcone/bcm_fullcone & shortcut-fe & natflow & ipv6-nat & custom nft command option
pushd customfeeds/luci
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/openwrt-24.10/0001-luci-app-firewall-add-nft-fullcone-and-bcm-fullcone-.patch | patch -p1
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/openwrt-24.10/0002-luci-app-firewall-add-shortcut-fe-option.patch | patch -p1
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/openwrt-24.10/0003-luci-app-firewall-add-ipv6-nat-option.patch | patch -p1
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/openwrt-24.10/0004-luci-add-firewall-add-custom-nft-rule-support.patch | patch -p1
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/openwrt-24.10/0005-luci-app-firewall-add-natflow-offload-support.patch | patch -p1
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/openwrt-24.10/0006-luci-app-firewall-enable-hardware-offload-only-on-de.patch | patch -p1

# openssl - quictls
pushd package/libs/openssl/patches
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0001-QUIC-Add-support-for-BoringSSL-QUIC-APIs.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0002-QUIC-New-method-to-get-QUIC-secret-length.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0003-QUIC-Make-temp-secret-names-less-confusing.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0004-QUIC-Move-QUIC-transport-params-to-encrypted-extensi.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0005-QUIC-Use-proper-secrets-for-handshake.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0006-QUIC-Handle-partial-handshake-messages.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0007-QUIC-Fix-quic_transport-constructors-parsers.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0008-QUIC-Reset-init-state-in-SSL_process_quic_post_hands.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0009-QUIC-Don-t-process-an-incomplete-message.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0010-QUIC-Quick-fix-s2c-to-c2s-for-early-secret.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0011-QUIC-Add-client-early-traffic-secret-storage.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0012-QUIC-Add-OPENSSL_NO_QUIC-wrapper.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0013-QUIC-Correctly-disable-middlebox-compat.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0014-QUIC-Move-QUIC-code-out-of-tls13_change_cipher_state.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0015-QUIC-Tweeks-to-quic_change_cipher_state.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0016-QUIC-Add-support-for-more-secrets.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0017-QUIC-Fix-resumption-secret.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0018-QUIC-Handle-EndOfEarlyData-and-MaxEarlyData.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0019-QUIC-Fall-through-for-0RTT.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0020-QUIC-Some-cleanup-for-the-main-QUIC-changes.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0021-QUIC-Prevent-KeyUpdate-for-QUIC.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0022-QUIC-Test-KeyUpdate-rejection.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0023-QUIC-Buffer-all-provided-quic-data.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0024-QUIC-Enforce-consistent-encryption-level-for-handsha.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0025-QUIC-add-v1-quic_transport_parameters.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0026-QUIC-return-success-when-no-post-handshake-data.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0027-QUIC-__owur-makes-no-sense-for-void-return-values.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0028-QUIC-remove-SSL_R_BAD_DATA_LENGTH-unused.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0029-QUIC-SSLerr-ERR_raise-ERR_LIB_SSL.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0030-QUIC-Add-compile-run-time-checking-for-QUIC.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0031-QUIC-Add-early-data-support.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0032-QUIC-Make-SSL_provide_quic_data-accept-0-length-data.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0033-QUIC-Process-multiple-post-handshake-messages-in-a-s.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0034-QUIC-Fix-CI.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0035-QUIC-Break-up-header-body-processing.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0036-QUIC-Don-t-muck-with-FIPS-checksums.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0037-QUIC-Update-RFC-references.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0038-QUIC-revert-white-space-change.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0039-QUIC-use-SSL_IS_QUIC-in-more-places.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0040-QUIC-Error-when-non-empty-session_id-in-CH.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0041-QUIC-Update-SSL_clear-to-clear-quic-data.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0042-QUIC-Better-SSL_clear.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0043-QUIC-Fix-extension-test.patch
curl -sO https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0044-QUIC-Update-metadata-version.patch
popd

# openssl urandom
sed -i "/-openwrt/iOPENSSL_OPTIONS += enable-ktls '-DDEVRANDOM=\"\\\\\"/dev/urandom\\\\\"\"\'\n" package/libs/openssl/Makefile

# openssl - lto
sed -i "s/ no-lto//g" package/libs/openssl/Makefile
sed -i "/TARGET_CFLAGS +=/ s/\$/ -ffat-lto-objects/" package/libs/openssl/Makefile
fi

# nghttp3
rm -rf customfeeds/packages/libs/nghttp3
git clone https://github.com/sbwml/package_libs_nghttp3 customfeeds/packages/libs/nghttp3

# ngtcp2
rm -rf customfeeds/packages/libs/ngtcp2
git clone https://github.com/sbwml/package_libs_ngtcp2 customfeeds/packages/libs/ngtcp2

# curl - fix passwall `time_pretransfer` check
rm -rf customfeeds/packages/net/curl
git clone https://github.com/sbwml/feeds_packages_net_curl customfeeds/packages/net/curl

# Docker
rm -rf customfeeds/luci/applications/luci-app-dockerman
git clone https://git.cooluc.com/sbwml/luci-app-dockerman -b openwrt-23.05 customfeeds/luci/applications/luci-app-dockerman
rm -rf customfeeds/packages/utils/{docker,dockerd,containerd,runc}
git clone https://github.com/sbwml/packages_utils_docker customfeeds/packages/utils/docker
git clone https://github.com/sbwml/packages_utils_dockerd customfeeds/packages/utils/dockerd
git clone https://github.com/sbwml/packages_utils_containerd customfeeds/packages/utils/containerd
git clone https://github.com/sbwml/packages_utils_runc customfeeds/packages/utils/runc
sed -i '/sysctl.d/d' customfeeds/packages/utils/dockerd/Makefile
pushd customfeeds/packages
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/docker/0001-dockerd-fix-bridge-network.patch | patch -p1
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/docker/0002-docker-add-buildkit-experimental-support.patch | patch -p1
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/docker/0003-dockerd-disable-ip6tables-for-bridge-network-by-defa.patch | patch -p1
popd

# cgroupfs-mount
# fix unmount hierarchical mount
pushd customfeeds/packages
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/cgroupfs-mount/0001-fix-cgroupfs-mount.patch | patch -p1
popd
# mount cgroup v2 hierarchy to /sys/fs/cgroup/cgroup2
mkdir -p customfeeds/packages/utils/cgroupfs-mount/patches
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/cgroupfs-mount/900-mount-cgroup-v2-hierarchy-to-sys-fs-cgroup-cgroup2.patch > customfeeds/packages/utils/cgroupfs-mount/patches/900-mount-cgroup-v2-hierarchy-to-sys-fs-cgroup-cgroup2.patch
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/cgroupfs-mount/901-fix-cgroupfs-umount.patch > customfeeds/packages/utils/cgroupfs-mount/patches/901-fix-cgroupfs-umount.patch
# docker systemd support
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/cgroupfs-mount/902-mount-sys-fs-cgroup-systemd-for-docker-systemd-suppo.patch > customfeeds/packages/utils/cgroupfs-mount/patches/902-mount-sys-fs-cgroup-systemd-for-docker-systemd-suppo.patch

# procps-ng - top
sed -i 's/enable-skill/enable-skill --disable-modern-top/g' customfeeds/packages/utils/procps-ng/Makefile

# TTYD
sed -i 's/services/system/g' customfeeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i '3 a\\t\t"order": 50,' customfeeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g' customfeeds/packages/utils/ttyd/files/ttyd.init
sed -i 's/procd_set_param stderr 1/procd_set_param stderr 0/g' customfeeds/packages/utils/ttyd/files/ttyd.init

# UPnP
rm -rf customfeeds/{packages/net/miniupnpd,luci/applications/luci-app-upnp}
git clone https://git.cooluc.com/sbwml/miniupnpd customfeeds/packages/net/miniupnpd -b v2.3.7
git clone https://git.cooluc.com/sbwml/luci-app-upnp customfeeds/luci/applications/luci-app-upnp -b main

# nginx - latest version
rm -rf customfeeds/packages/net/nginx
git clone https://github.com/sbwml/feeds_packages_net_nginx customfeeds/packages/net/nginx -b openwrt-24.10
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g;s/procd_set_param stderr 1/procd_set_param stderr 0/g' customfeeds/packages/net/nginx/files/nginx.init

# nginx - ubus
sed -i 's/ubus_parallel_req 2/ubus_parallel_req 6/g' customfeeds/packages/net/nginx/files-luci-support/60_nginx-luci-support
sed -i '/ubus_parallel_req/a\        ubus_script_timeout 300;' customfeeds/packages/net/nginx/files-luci-support/60_nginx-luci-support

# nginx - uwsgi timeout & enable brotli
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/nginx/luci.locations > customfeeds/packages/net/nginx/files-luci-support/luci.locations
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/nginx/openwrt-24.10-uci.conf.template > customfeeds/packages/net/nginx-util/files/uci.conf.template

# opkg
mkdir -p package/system/opkg/patches
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/opkg/900-opkg-download-disable-hsts.patch > package/system/opkg/patches/900-opkg-download-disable-hsts.patch

# uwsgi - fix timeout
sed -i '$a cgi-timeout = 600' customfeeds/packages/net/uwsgi/files-luci-support/luci-*.ini
sed -i '/limit-as/c\limit-as = 5000' customfeeds/packages/net/uwsgi/files-luci-support/luci-webui.ini
# disable error log
sed -i "s/procd_set_param stderr 1/procd_set_param stderr 0/g" customfeeds/packages/net/uwsgi/files/uwsgi.init

# uwsgi - performance
sed -i 's/threads = 1/threads = 2/g' customfeeds/packages/net/uwsgi/files-luci-support/luci-webui.ini
sed -i 's/processes = 3/processes = 4/g' customfeeds/packages/net/uwsgi/files-luci-support/luci-webui.ini
sed -i 's/cheaper = 1/cheaper = 2/g' customfeeds/packages/net/uwsgi/files-luci-support/luci-webui.ini

# rpcd - fix timeout
sed -i 's/option timeout 30/option timeout 60/g' package/system/rpcd/files/rpcd.config
sed -i 's#20) \* 1000#60) \* 1000#g' customfeeds/luci/modules/luci-base/htdocs/luci-static/resources/rpc.js

# luci-mod extra
pushd customfeeds/luci
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/luci/0001-luci-mod-system-add-modal-overlay-dialog-to-reboot.patch | patch -p1
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/luci/0002-luci-mod-status-displays-actual-process-memory-usage.patch | patch -p1
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/luci/0003-luci-mod-status-storage-index-applicable-only-to-val.patch | patch -p1
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/luci/0004-luci-mod-status-firewall-disable-legacy-firewall-rul.patch | patch -p1
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/luci/0005-luci-mod-system-add-refresh-interval-setting.patch | patch -p1
popd

# Luci diagnostics.js
sed -i "s/openwrt.org/www.qq.com/g" customfeeds/luci/modules/luci-mod-network/htdocs/luci-static/resources/view/network/diagnostics.js

# luci - rollback dhcp.js
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/luci/dhcp/openwrt-24.10-dhcp.js > customfeeds/luci/modules/luci-mod-network/htdocs/luci-static/resources/view/network/dhcp.js

# odhcpd RFC-9096
mkdir -p package/network/services/odhcpd/patches
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/odhcpd/001-odhcpd-RFC-9096-compliance-openwrt-24.10.patch > package/network/services/odhcpd/patches/001-odhcpd-RFC-9096-compliance.patch
pushd customfeeds/luci
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/odhcpd/luci-mod-network-add-option-for-ipv6-max-plt-vlt.patch | patch -p1
popd

# urngd - 2020-01-21
rm -rf package/system/urngd
git clone https://github.com/sbwml/package_system_urngd package/system/urngd

# zlib - 1.3
ZLIB_VERSION=1.3.1
ZLIB_HASH=38ef96b8dfe510d42707d9c781877914792541133e1870841463bfa73f883e32
sed -ri "s/(PKG_VERSION:=)[^\"]*/\1$ZLIB_VERSION/;s/(PKG_HASH:=)[^\"]*/\1$ZLIB_HASH/" package/libs/zlib/Makefile

# profile
sed -i 's#\\u@\\h:\\w\\\$#\\[\\e[32;1m\\][\\u@\\h\\[\\e[0m\\] \\[\\033[01;34m\\]\\W\\[\\033[00m\\]\\[\\e[32;1m\\]]\\[\\e[0m\\]\\\$#g' package/base-files/files/etc/profile
sed -ri 's/(export PATH=")[^"]*/\1%PATH%:\/opt\/bin:\/opt\/sbin:\/opt\/usr\/bin:\/opt\/usr\/sbin/' package/base-files/files/etc/profile
sed -i '/PS1/a\export TERM=xterm-color' package/base-files/files/etc/profile

# bash
sed -i 's#ash#bash#g' package/base-files/files/etc/passwd
sed -i '\#export ENV=/etc/shinit#a export HISTCONTROL=ignoredups' package/base-files/files/etc/profile
mkdir -p files/root
curl -so files/root/.bash_profile https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/files/root/.bash_profile
curl -so files/root/.bashrc https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/files/root/.bashrc

# rootfs files
mkdir -p files/etc/sysctl.d
curl -so files/etc/sysctl.d/15-vm-swappiness.conf https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/files/etc/sysctl.d/15-vm-swappiness.conf
curl -so files/etc/sysctl.d/16-udp-buffer-size.conf https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/files/etc/sysctl.d/16-udp-buffer-size.conf

# NTP
sed -i 's/0.openwrt.pool.ntp.org/ntp1.aliyun.com/g' package/base-files/files/bin/config_generate
sed -i 's/1.openwrt.pool.ntp.org/ntp2.aliyun.com/g' package/base-files/files/bin/config_generate
sed -i 's/2.openwrt.pool.ntp.org/time1.cloud.tencent.com/g' package/base-files/files/bin/config_generate
sed -i 's/3.openwrt.pool.ntp.org/time2.cloud.tencent.com/g' package/base-files/files/bin/config_generate
