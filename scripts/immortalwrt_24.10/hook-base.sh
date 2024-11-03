#!/bin/bash
# Set to local prepare

# tools: add llvm/clang toolchain
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0001-tools-add-llvm-clang-toolchain.patch | patch -p1

# tools: add upx tools
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0002-tools-add-upx-tools.patch | patch -p1

# rootfs: upx compression
# include/rootfs.mk
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0003-rootfs-add-upx-compression-support.patch | patch -p1

# rootfs: add r/w (0600) permissions for UCI configuration files
# include/rootfs.mk
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0004-rootfs-add-r-w-permissions-for-UCI-configuration-fil.patch | patch -p1

# rootfs: Add support for local kmod installation sources
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0005-rootfs-Add-support-for-local-kmod-installation-sourc.patch | patch -p1

# BTF: fix failed to validate module
# config/Config-kernel.in patch
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0006-kernel-add-MODULE_ALLOW_BTF_MISMATCH-option.patch | patch -p1

# kernel: Add support for llvm/clang compiler
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0007-kernel-Add-support-for-llvm-clang-compiler.patch | patch -p1

# toolchain: Add libquadmath to the toolchain
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0008-libquadmath-Add-libquadmath-to-the-toolchain.patch | patch -p1

# kernel: linux-6.11 config
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic/0010-include-kernel-add-miss-config-for-linux-6.11.patch | patch -p1

# meson: add platform variable to cross-compilation file
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0011-meson-add-platform-variable-to-cross-compilation-fil.patch | patch -p1

# fstools
rm -rf package/system/fstools
git clone https://github.com/sbwml/package_system_fstools -b openwrt-24.10 package/system/fstools

# util-linux
rm -rf package/utils/util-linux
git clone https://github.com/sbwml/package_utils_util-linux -b openwrt-24.10 package/utils/util-linux

# Shortcut Forwarding Engine
git clone https://git.cooluc.com/sbwml/shortcut-fe package/new/shortcut-fe

# FullCone module
git clone https://git.cooluc.com/sbwml/nft-fullcone package/new/nft-fullcone

# IPv6 NAT
git clone https://github.com/sbwml/packages_new_nat6 package/new/nat6

# natflow
git clone https://github.com/sbwml/package_new_natflow package/new/natflow

# Patch Luci add nft_fullcone/bcm_fullcone & shortcut-fe & natflow & ipv6-nat & custom nft command option
pushd feeds/luci
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/openwrt-24.10/0001-luci-app-firewall-add-nft-fullcone-and-bcm-fullcone-.patch | patch -p1
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/openwrt-24.10/0002-luci-app-firewall-add-shortcut-fe-option.patch | patch -p1
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/openwrt-24.10/0003-luci-app-firewall-add-ipv6-nat-option.patch | patch -p1
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/openwrt-24.10/0004-luci-add-firewall-add-custom-nft-rule-support.patch | patch -p1
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/openwrt-24.10/0005-luci-app-firewall-add-natflow-offload-support.patch | patch -p1
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/openwrt-24.10/0006-luci-app-firewall-enable-hardware-offload-only-on-de.patch | patch -p1
popd

# openssl - quictls
# rm -rf package/libs/openssl
# cp -r $GITHUB_WORKSPACE/data/openwrt-23.05/package/libs/openssl package/libs/openssl
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

# grub2 -  disable `gc-sections` flag
# sed -i '/PKG_BUILD_FLAGS/ s/$/ no-gc-sections/' package/boot/grub2/Makefile

# haproxy - fix build with quictls
sed -i '/USE_QUIC_OPENSSL_COMPAT/d' customfeeds/packages/net/haproxy/Makefile

# nghttp3
rm -rf customfeeds/packages/libs/nghttp3
git clone https://github.com/sbwml/package_libs_nghttp3 customfeeds/packages/libs/nghttp3

# ngtcp2
rm -rf customfeeds/packages/libs/ngtcp2
git clone https://github.com/sbwml/package_libs_ngtcp2 customfeeds/packages/libs/ngtcp2

# curl - fix passwall `time_pretransfer` check
rm -rf customfeeds/packages/net/curl
git clone https://github.com/sbwml/feeds_packages_net_curl customfeeds/packages/net/curl

# TTYD
sed -i 's/services/system/g' customfeeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i '3 a\\t\t"order": 50,' customfeeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g' customfeeds/packages/utils/ttyd/files/ttyd.init
sed -i 's/procd_set_param stderr 1/procd_set_param stderr 0/g' customfeeds/packages/utils/ttyd/files/ttyd.init

# nginx - latest version
# rm -rf customfeeds/packages/net/nginx
# git clone https://github.com/sbwml/feeds_packages_net_nginx customfeeds/packages/net/nginx -b openwrt-23.05
# sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g;s/procd_set_param stderr 1/procd_set_param stderr 0/g' customfeeds/packages/net/nginx/files/nginx.init

# nginx - ubus
# sed -i 's/ubus_parallel_req 2/ubus_parallel_req 6/g' customfeeds/packages/net/nginx/files-luci-support/60_nginx-luci-support
# sed -i '/ubus_parallel_req/a\        ubus_script_timeout 300;' customfeeds/packages/net/nginx/files-luci-support/60_nginx-luci-support

# nginx - uwsgi timeout & enable brotli
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/nginx/luci.locations > customfeeds/packages/net/nginx/files-luci-support/luci.locations
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/nginx/openwrt-23.05-uci.conf.template > customfeeds/packages/net/nginx-util/files/uci.conf.template

# libwebsockets
# mkdir -p customfeeds/packages/libs/libwebsockets/patches
# pushd customfeeds/packages/libs/libwebsockets/patches
# curl -sLO https://raw.githubusercontent.com/openwrt/packages/bcd970fb4ff6029fbf612dccf6d8c2902a65e20e/libs/libwebsockets/patches/010-fix-enum-int-mismatch-openssl.patch
# curl -sLO https://raw.githubusercontent.com/openwrt/packages/bcd970fb4ff6029fbf612dccf6d8c2902a65e20e/libs/libwebsockets/patches/011-fix-enum-int-mismatch-mbedtls.patch
# curl -sLO https://raw.githubusercontent.com/openwrt/packages/94bd1ca8bad053a772a3ea8cb06ce59241fb9a57/libs/libwebsockets/patches/100-fix-uninitialized-variable-usage.patch
# popd

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
sed -i "s/openwrt.org/baidu.com/g" customfeeds/luci/modules/luci-mod-network/htdocs/luci-static/resources/view/network/diagnostics.js

# profile
sed -i 's#\\u@\\h:\\w\\\$#\\[\\e[32;1m\\][\\u@\\h\\[\\e[0m\\] \\[\\033[01;34m\\]\\W\\[\\033[00m\\]\\[\\e[32;1m\\]]\\[\\e[0m\\]\\\$#g' package/base-files/files/etc/profile
sed -ri 's/(export PATH=")[^"]*/\1%PATH%:\/opt\/bin:\/opt\/sbin:\/opt\/usr\/bin:\/opt\/usr\/sbin/' package/base-files/files/etc/profile
sed -i '/PS1/a\export TERM=xterm-color' package/base-files/files/etc/profile

# BBRv3 - linux-6.6/6.12
pushd target/linux/generic/backport-6.6
curl -Os https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0001-net-tcp_bbr-broaden-app-limited-rate-sample-detectio.patch
curl -Os https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0002-net-tcp_bbr-v2-shrink-delivered_mstamp-first_tx_msta.patch
curl -Os https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0003-net-tcp_bbr-v2-snapshot-packets-in-flight-at-transmi.patch
curl -Os https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0004-net-tcp_bbr-v2-count-packets-lost-over-TCP-rate-samp.patch
curl -Os https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0005-net-tcp_bbr-v2-export-FLAG_ECE-in-rate_sample.is_ece.patch
curl -Os https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0006-net-tcp_bbr-v2-introduce-ca_ops-skb_marked_lost-CC-m.patch
curl -Os https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0007-net-tcp_bbr-v2-adjust-skb-tx.in_flight-upon-merge-in.patch
curl -Os https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0008-net-tcp_bbr-v2-adjust-skb-tx.in_flight-upon-split-in.patch
curl -Os https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0009-net-tcp-add-new-ca-opts-flag-TCP_CONG_WANTS_CE_EVENT.patch
curl -Os https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0010-net-tcp-re-generalize-TSO-sizing-in-TCP-CC-module-AP.patch
curl -Os https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0011-net-tcp-add-fast_ack_mode-1-skip-rwin-check-in-tcp_f.patch
curl -Os https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0012-net-tcp_bbr-v2-record-app-limited-status-of-TLP-repa.patch
curl -Os https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0013-net-tcp_bbr-v2-inform-CC-module-of-losses-repaired-b.patch
curl -Os https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0014-net-tcp_bbr-v2-introduce-is_acking_tlp_retrans_seq-i.patch
curl -Os https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0015-tcp-introduce-per-route-feature-RTAX_FEATURE_ECN_LOW.patch
curl -Os https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0016-net-tcp_bbr-v3-update-TCP-bbr-congestion-control-mod.patch
curl -Os https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0017-net-tcp_bbr-v3-ensure-ECN-enabled-BBR-flows-set-ECT-.patch
curl -Os https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/bbr3/010-bbr3-0018-tcp-export-TCPI_OPT_ECN_LOW-in-tcp_info-tcpi_options.patch
popd

# kernel patch
# btf: silence btf module warning messages
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/btf/990-btf-silence-btf-module-warning-messages.patch > target/linux/generic/hack-6.6/990-btf-silence-btf-module-warning-messages.patch
# cpu model
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/arm64/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch > target/linux/generic/pending-6.6/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch
# fullcone
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/net/952-net-conntrack-events-support-multiple-registrant.patch > target/linux/generic/hack-6.6/952-net-conntrack-events-support-multiple-registrant.patch
# bcm-fullcone
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/net/982-add-bcm-fullcone-support.patch > target/linux/generic/hack-6.6/982-add-bcm-fullcone-support.patch
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/net/983-add-bcm-fullcone-nft_masq-support.patch > target/linux/generic/hack-6.6/983-add-bcm-fullcone-nft_masq-support.patch
# shortcut-fe
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/net/601-netfilter-export-udp_get_timeouts-function.patch > target/linux/generic/hack-6.6/601-netfilter-export-udp_get_timeouts-function.patch
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/net/953-net-patch-linux-kernel-to-support-shortcut-fe.patch > target/linux/generic/hack-6.6/953-net-patch-linux-kernel-to-support-shortcut-fe.patch
# backport - 6.8 fast-path-variables
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/backport/901-v6.8-cache-enforce-cache-groups.patch > target/linux/generic/backport-6.6/901-v6.8-cache-enforce-cache-groups.patch
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/backport/902-v6.8-netns-ipv4-reorganize-netns_ipv4-fast-path-variables.patch > target/linux/generic/backport-6.6/902-v6.8-netns-ipv4-reorganize-netns_ipv4-fast-path-variables.patch
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/backport/903-v6.8-net-device-reorganize-net_device-fast-path-variables.patch > target/linux/generic/backport-6.6/903-v6.8-net-device-reorganize-net_device-fast-path-variables.patch
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/backport/904-v6.8-tcp-reorganize-tcp_sock-fast-path-variables.patch > target/linux/generic/backport-6.6/904-v6.8-tcp-reorganize-tcp_sock-fast-path-variables.patch
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/backport/905-v6.8-tcp-move-tp-scaling_ratio-to-tcp_sock_read_txrx-grou.patch > target/linux/generic/backport-6.6/905-v6.8-tcp-move-tp-scaling_ratio-to-tcp_sock_read_txrx-grou.patch

# nat46
# mkdir -p package/kernel/nat46/patches
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/nat46/100-fix-build-with-kernel-6.9.patch > package/kernel/nat46/patches/100-fix-build-with-kernel-6.9.patch
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/nat46/101-fix-build-with-kernel-6.12.patch > package/kernel/nat46/patches/101-fix-build-with-kernel-6.12.patch

# clang
# xtables-addons module
rm -rf customfeeds/packages/net/xtables-addons
git clone https://github.com/sbwml/kmod_packages_net_xtables-addons customfeeds/packages/net/xtables-addons
# netatop
sed -i 's/$(MAKE)/$(KERNEL_MAKE)/g' customfeeds/packages/admin/netatop/Makefile
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/clang/netatop/900-fix-build-with-clang.patch > customfeeds/packages/admin/netatop/patches/900-fix-build-with-clang.patch
# dmx_usb_module
rm -rf customfeeds/packages/libs/dmx_usb_module
git clone https://git.cooluc.com/sbwml/feeds_packages_libs_dmx_usb_module customfeeds/packages/libs/dmx_usb_module
# macremapper
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/clang/macremapper/100-macremapper-fix-clang-build.patch | patch -p1
# coova-chilli module
rm -rf customfeeds/packages/net/coova-chilli
git clone https://github.com/sbwml/kmod_packages_net_coova-chilli customfeeds/packages/net/coova-chilli

# watchcat - clean config
# true > customfeeds/packages/utils/watchcat/files/watchcat.config
