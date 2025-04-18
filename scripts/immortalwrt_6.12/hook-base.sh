#!/bin/bash
# Set to local prepare

# patch source
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0005-kernel-Add-support-for-llvm-clang-compiler.patch | patch -p1
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0006-build-kernel-add-out-of-tree-kernel-config.patch | patch -p1
# curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0010-kernel-add-PREEMPT_RT-support-for-aarch64-x86_64.patch | patch -p1

# apk-tools
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/apk-tools/9999-hack-for-linux-pre-releases.patch > package/system/apk/patches/9999-hack-for-linux-pre-releases.patch

# x86 - disable mitigations
sed -i 's/noinitrd/noinitrd mitigations=off/g' target/linux/x86/image/grub-efi.cfg

# fstools
rm -rf package/system/fstools
git clone https://github.com/sbwml/package_system_fstools -b openwrt-24.10 package/system/fstools

# util-linux
rm -rf package/utils/util-linux
git clone https://github.com/sbwml/package_utils_util-linux -b openwrt-24.10 package/utils/util-linux

# Shortcut Forwarding Engine
# git clone https://git.cooluc.com/sbwml/shortcut-fe package/new/shortcut-fe

# FullCone module
rm -rf package/network/utils/fullconenat-nft
git clone https://git.cooluc.com/sbwml/nft-fullcone package/network/utils/fullconenat-nft

# IPv6 NAT
git clone https://github.com/sbwml/packages_new_nat6 package/new/nat6

# natflow
git clone https://github.com/sbwml/package_new_natflow package/new/natflow

# openssl - quictls
pushd package/libs/openssl/patches
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0001-QUIC-Add-support-for-BoringSSL-QUIC-APIs.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0002-QUIC-New-method-to-get-QUIC-secret-length.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0003-QUIC-Make-temp-secret-names-less-confusing.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0004-QUIC-Move-QUIC-transport-params-to-encrypted-extensi.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0005-QUIC-Use-proper-secrets-for-handshake.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0006-QUIC-Handle-partial-handshake-messages.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0007-QUIC-Fix-quic_transport-constructors-parsers.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0008-QUIC-Reset-init-state-in-SSL_process_quic_post_hands.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0009-QUIC-Don-t-process-an-incomplete-message.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0010-QUIC-Quick-fix-s2c-to-c2s-for-early-secret.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0011-QUIC-Add-client-early-traffic-secret-storage.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0012-QUIC-Add-OPENSSL_NO_QUIC-wrapper.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0013-QUIC-Correctly-disable-middlebox-compat.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0014-QUIC-Move-QUIC-code-out-of-tls13_change_cipher_state.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0015-QUIC-Tweeks-to-quic_change_cipher_state.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0016-QUIC-Add-support-for-more-secrets.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0017-QUIC-Fix-resumption-secret.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0018-QUIC-Handle-EndOfEarlyData-and-MaxEarlyData.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0019-QUIC-Fall-through-for-0RTT.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0020-QUIC-Some-cleanup-for-the-main-QUIC-changes.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0021-QUIC-Prevent-KeyUpdate-for-QUIC.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0022-QUIC-Test-KeyUpdate-rejection.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0023-QUIC-Buffer-all-provided-quic-data.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0024-QUIC-Enforce-consistent-encryption-level-for-handsha.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0025-QUIC-add-v1-quic_transport_parameters.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0026-QUIC-return-success-when-no-post-handshake-data.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0027-QUIC-__owur-makes-no-sense-for-void-return-values.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0028-QUIC-remove-SSL_R_BAD_DATA_LENGTH-unused.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0029-QUIC-SSLerr-ERR_raise-ERR_LIB_SSL.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0030-QUIC-Add-compile-run-time-checking-for-QUIC.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0031-QUIC-Add-early-data-support.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0032-QUIC-Make-SSL_provide_quic_data-accept-0-length-data.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0033-QUIC-Process-multiple-post-handshake-messages-in-a-s.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0034-QUIC-Fix-CI.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0035-QUIC-Break-up-header-body-processing.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0036-QUIC-Don-t-muck-with-FIPS-checksums.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0037-QUIC-Update-RFC-references.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0038-QUIC-revert-white-space-change.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0039-QUIC-use-SSL_IS_QUIC-in-more-places.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0040-QUIC-Error-when-non-empty-session_id-in-CH.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0041-QUIC-Update-SSL_clear-to-clear-quic-data.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0042-QUIC-Better-SSL_clear.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0043-QUIC-Fix-extension-test.patch
curl -sO https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/openssl/quic/0044-QUIC-Update-metadata-version.patch
popd

# openssl urandom
sed -i "/-openwrt/iOPENSSL_OPTIONS += enable-ktls '-DDEVRANDOM=\"\\\\\"/dev/urandom\\\\\"\"\'\n" package/libs/openssl/Makefile

# openssl - lto
sed -i "s/ no-lto//g" package/libs/openssl/Makefile
sed -i "/TARGET_CFLAGS +=/ s/\$/ -ffat-lto-objects/" package/libs/openssl/Makefile

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

# opkg
# mkdir -p package/system/opkg/patches
# curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/opkg/900-opkg-download-disable-hsts.patch > package/system/opkg/patches/900-opkg-download-disable-hsts.patch

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
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/luci/0001-luci-mod-system-add-modal-overlay-dialog-to-reboot.patch | patch -p1
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/luci/0002-luci-mod-status-displays-actual-process-memory-usage.patch | patch -p1
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/luci/0003-luci-mod-status-storage-index-applicable-only-to-val.patch | patch -p1
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/luci/0004-luci-mod-status-firewall-disable-legacy-firewall-rul.patch | patch -p1
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/luci/0005-luci-mod-system-add-refresh-interval-setting.patch | patch -p1
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/luci/0006-luci-mod-system-mounts-add-docker-directory-mount-po.patch | patch -p1
popd

# Luci diagnostics.js
sed -i "s/immortalwrt.org/www.baidu.com/g" customfeeds/luci/modules/luci-mod-network/htdocs/luci-static/resources/view/network/diagnostics.js

# profile
sed -i 's#\\u@\\h:\\w\\\$#\\[\\e[32;1m\\][\\u@\\h\\[\\e[0m\\] \\[\\033[01;34m\\]\\W\\[\\033[00m\\]\\[\\e[32;1m\\]]\\[\\e[0m\\]\\\$#g' package/base-files/files/etc/profile
sed -ri 's/(export PATH=")[^"]*/\1%PATH%:\/opt\/bin:\/opt\/sbin:\/opt\/usr\/bin:\/opt\/usr\/sbin/' package/base-files/files/etc/profile
sed -i '/PS1/a\export TERM=xterm-color' package/base-files/files/etc/profile

# BBRv3 - linux-6.12
pushd target/linux/generic/backport-6.12
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0001-net-tcp_bbr-broaden-app-limited-rate-sample-detectio.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0002-net-tcp_bbr-v2-shrink-delivered_mstamp-first_tx_msta.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0003-net-tcp_bbr-v2-snapshot-packets-in-flight-at-transmi.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0004-net-tcp_bbr-v2-count-packets-lost-over-TCP-rate-samp.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0005-net-tcp_bbr-v2-export-FLAG_ECE-in-rate_sample.is_ece.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0006-net-tcp_bbr-v2-introduce-ca_ops-skb_marked_lost-CC-m.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0007-net-tcp_bbr-v2-adjust-skb-tx.in_flight-upon-merge-in.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0008-net-tcp_bbr-v2-adjust-skb-tx.in_flight-upon-split-in.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0009-net-tcp-add-new-ca-opts-flag-TCP_CONG_WANTS_CE_EVENT.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0010-net-tcp-re-generalize-TSO-sizing-in-TCP-CC-module-AP.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0011-net-tcp-add-fast_ack_mode-1-skip-rwin-check-in-tcp_f.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0012-net-tcp_bbr-v2-record-app-limited-status-of-TLP-repa.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0013-net-tcp_bbr-v2-inform-CC-module-of-losses-repaired-b.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0014-net-tcp_bbr-v2-introduce-is_acking_tlp_retrans_seq-i.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0015-tcp-introduce-per-route-feature-RTAX_FEATURE_ECN_LOW.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0016-net-tcp_bbr-v3-update-TCP-bbr-congestion-control-mod.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0017-net-tcp_bbr-v3-ensure-ECN-enabled-BBR-flows-set-ECT-.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0018-tcp-export-TCPI_OPT_ECN_LOW-in-tcp_info-tcpi_options.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0019-x86-cfi-bpf-Add-tso_segs-and-skb_marked_lost-to-bpf_.patch
popd

# linux-rt - i915
pushd target/linux/generic/hack-6.12
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/linux-rt/012-0001-drm-i915-Use-preempt_disable-enable_rt-where-recomme.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/linux-rt/012-0002-drm-i915-Don-t-disable-interrupts-on-PREEMPT_RT-duri.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/linux-rt/012-0003-drm-i915-Don-t-check-for-atomic-context-on-PREEMPT_R.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/linux-rt/012-0004-drm-i915-Disable-tracing-points-on-PREEMPT_RT.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/linux-rt/012-0005-drm-i915-gt-Use-spin_lock_irq-instead-of-local_irq_d.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/linux-rt/012-0006-drm-i915-Drop-the-irqs_disabled-check.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/linux-rt/012-0007-drm-i915-guc-Consider-also-RCU-depth-in-busy-loop.patch
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/linux-rt/012-0008-Revert-drm-i915-Depend-on-PREEMPT_RT.patch
popd

# iproute2 - bbr3
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/iproute2/900-ss-output-TCP-BBRv3-diag-information.patch > package/network/utils/iproute2/patches/900-ss-output-TCP-BBRv3-diag-information.patch
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/iproute2/901-ip-introduce-the-ecn_low-per-route-feature.patch > package/network/utils/iproute2/patches/901-ip-introduce-the-ecn_low-per-route-feature.patch
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/iproute2/902-ss-display-ecn_low-if-tcp_info-tcpi_options-TCPI_OPT.patch > package/network/utils/iproute2/patches/902-ss-display-ecn_low-if-tcp_info-tcpi_options-TCPI_OPT.patch

# bpf-headers - 6.12
sed -ri "s/(PKG_PATCHVER:=)[^\"]*/\16.12/" package/kernel/bpf-headers/Makefile

# watchcat - clean config
# true > customfeeds/packages/utils/watchcat/files/watchcat.config
