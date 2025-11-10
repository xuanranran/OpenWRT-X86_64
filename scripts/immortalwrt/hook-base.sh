#!/bin/bash
# Set to local prepare

# apk-tools
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/apk-tools/9999-hack-for-linux-pre-releases.patch > package/system/apk/patches/9999-hack-for-linux-pre-releases.patch

curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0005-kernel-Add-support-for-llvm-clang-compiler.patch | patch -p1
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/generic-24.10/0006-build-kernel-add-out-of-tree-kernel-config.patch | patch -p1
echo "# CONFIG_KMSAN is not set" >> target/linux/x86/config-6.12

# x86 - disable mitigations
sed -i 's/noinitrd/noinitrd mitigations=off/g' target/linux/x86/image/grub-efi.cfg

# fstools
pushd package/system/fstools
patch -p1 < $GITHUB_WORKSPACE/data/fstools-add-xfs-ntfs3-extroot-support-and-fix-packaging.patch
popd

# util-linux
mkdir -p package/utils/util-linux/patches
curl -s https://raw.githubusercontent.com/sbwml/package_utils_util-linux/refs/heads/openwrt-24.10/patches/0001-ntfs-use-ntfs3-for-read-write-filesystem.patch > package/utils/util-linux/patches/0001-ntfs-use-ntfs3-for-read-write-filesystem.patch

# openssl urandom
sed -i "/-openwrt/iOPENSSL_OPTIONS += enable-ktls '-DDEVRANDOM=\"\\\\\"/dev/urandom\\\\\"\"\'\n" package/libs/openssl/Makefile

# openssl - lto
sed -i "s/ no-lto//g" package/libs/openssl/Makefile
sed -i "/TARGET_CFLAGS +=/ s/\$/ -ffat-lto-objects/" package/libs/openssl/Makefile

# nghttp3
# rm -rf customfeeds/packages/libs/nghttp3
# git clone https://github.com/sbwml/package_libs_nghttp3 customfeeds/packages/libs/nghttp3

# ngtcp2
# rm -rf customfeeds/packages/libs/ngtcp2
# git clone https://github.com/sbwml/package_libs_ngtcp2 customfeeds/packages/libs/ngtcp2

# curl - fix passwall `time_pretransfer` check
rm -rf customfeeds/packages/net/curl
git clone https://github.com/sbwml/feeds_packages_net_curl customfeeds/packages/net/curl

# TTYD
sed -i 's/services/system/g' customfeeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i '3 a\\t\t"order": 50,' customfeeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g' customfeeds/packages/utils/ttyd/files/ttyd.init
sed -i 's/procd_set_param stderr 1/procd_set_param stderr 0/g' customfeeds/packages/utils/ttyd/files/ttyd.init

# UPnP
rm -rf customfeeds/packages/net/miniupnpd
git clone https://git.cooluc.com/sbwml/miniupnpd customfeeds/packages/net/miniupnpd -b v2.3.9

# nginx - latest version
rm -rf customfeeds/packages/net/nginx
git clone https://github.com/sbwml/feeds_packages_net_nginx customfeeds/packages/net/nginx -b openwrt-24.10
sed -i 's/1.28.0/1.29.0/g' customfeeds/packages/net/nginx/Makefile
sed -i 's/c6b5c6b086c0df9d3ca3ff5e084c1d0ef909e6038279c71c1c3e985f576ff76a/109754dfe8e5169a7a0cf0db6718e7da2db495753308f933f161e525a579a664/g' customfeeds/packages/net/nginx/Makefile
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g;s/procd_set_param stderr 1/procd_set_param stderr 0/g' customfeeds/packages/net/nginx/files/nginx.init

# nginx - ubus
sed -i 's/ubus_parallel_req 2/ubus_parallel_req 6/g' customfeeds/packages/net/nginx/files-luci-support/60_nginx-luci-support
sed -i '/ubus_parallel_req/a\        ubus_script_timeout 300;' customfeeds/packages/net/nginx/files-luci-support/60_nginx-luci-support

# nginx - config
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/nginx/luci.locations > customfeeds/packages/net/nginx/files-luci-support/luci.locations
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/nginx/uci.conf.template > customfeeds/packages/net/nginx-util/files/uci.conf.template

# opkg
mkdir -p package/system/opkg/patches
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/opkg/900-opkg-download-disable-hsts.patch > package/system/opkg/patches/900-opkg-download-disable-hsts.patch
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/opkg/901-libopkg-opkg_install-copy-conffiles-to-the-system-co.patch > package/system/opkg/patches/901-libopkg-opkg_install-copy-conffiles-to-the-system-co.patch

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
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/luci/0007-luci-mod-system-add-ucitrack-luci-mod-system-zram.js.patch | patch -p1
popd

# Luci diagnostics.js
sed -i "s/immortalwrt.org/www.baidu.com/g" customfeeds/luci/modules/luci-mod-network/htdocs/luci-static/resources/view/network/diagnostics.js

# profile
sed -i 's#\\u@\\h:\\w\\\$#\\[\\e[32;1m\\][\\u@\\h\\[\\e[0m\\] \\[\\033[01;34m\\]\\W\\[\\033[00m\\]\\[\\e[32;1m\\]]\\[\\e[0m\\]\\\$#g' package/base-files/files/etc/profile
sed -ri 's/(export PATH=")[^"]*/\1%PATH%:\/opt\/bin:\/opt\/sbin:\/opt\/usr\/bin:\/opt\/usr\/sbin/' package/base-files/files/etc/profile
sed -i '/PS1/a\export TERM=xterm-color' package/base-files/files/etc/profile

# luci-compat - remove extra line breaks from description
sed -i '/<br \/>/d' customfeeds/luci/modules/luci-compat/luasrc/view/cbi/full_valuefooter.htm

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
curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/bbr3/010-bbr3-0020-net-tcp_bbr-v3-silence-Wconstant-logical-operand.patch
popd

# LRNG - 6.12
pushd target/linux/generic/hack-6.12
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0001-LRNG-Entropy-Source-and-DRNG-Manager.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0002-LRNG-allocate-one-DRNG-instance-per-NUMA-node.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0003-LRNG-proc-interface.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0004-LRNG-add-switchable-DRNG-support.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0005-LRNG-add-common-generic-hash-support.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0006-crypto-DRBG-externalize-DRBG-functions-for-LRNG.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0007-LRNG-add-SP800-90A-DRBG-extension.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0008-LRNG-add-kernel-crypto-API-PRNG-extension.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0009-LRNG-add-atomic-DRNG-implementation.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0010-LRNG-add-common-timer-based-entropy-source-code.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0011-LRNG-add-interrupt-entropy-source.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0012-scheduler-add-entropy-sampling-hook.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0013-LRNG-add-scheduler-based-entropy-source.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0014-LRNG-add-SP800-90B-compliant-health-tests.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0015-LRNG-add-random.c-entropy-source-support.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0016-LRNG-CPU-entropy-source.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0017-LRNG-add-Jitter-RNG-fast-noise-source.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0018-LRNG-add-option-to-enable-runtime-entropy-rate-confi.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0019-LRNG-add-interface-for-gathering-of-raw-entropy.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0020-LRNG-add-power-on-and-runtime-self-tests.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0021-LRNG-sysctls-and-proc-interface.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0022-LRMG-add-drop-in-replacement-random-4-API.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0023-LRNG-add-kernel-crypto-API-interface.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0024-LRNG-add-dev-lrng-device-file-support.patch
    curl -Os https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.12/lrng/011-LRNG-0025-LRNG-add-hwrand-framework-interface.patch
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

# luci-theme-bootstrap
sed -i 's/font-size: 13px/font-size: 14px/g' customfeeds/luci/themes/luci-theme-bootstrap/htdocs/luci-static/bootstrap/cascade.css
sed -i 's/9.75px/10.75px/g' customfeeds/luci/themes/luci-theme-bootstrap/htdocs/luci-static/bootstrap/cascade.css
