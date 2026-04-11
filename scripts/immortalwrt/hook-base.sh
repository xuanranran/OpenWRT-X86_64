#!/bin/bash
# Set to local prepare

mirror="https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master"
github="github.com"
gitea="git.cooluc.com"

# lto jobserver
sed -i 's/-flto=auto/-flto=jobserver/g' include/package.mk

curl -s $mirror/openwrt/patch/generic-25.12/0005-kernel-Add-support-for-llvm-clang-compiler.patch | patch -p1
curl -s $mirror/openwrt/patch/generic-25.12/0006-build-kernel-add-out-of-tree-kernel-config.patch | patch -p1

# add source mirror
sed -i '/"@OPENWRT": \[/a\\t\t"https://source.cooluc.com",' scripts/projectsmirrors.json

# attr no-mold
sed -i '/PKG_BUILD_PARALLEL/aPKG_BUILD_FLAGS:=no-mold' customfeeds/packages/utils/attr/Makefile

# x86 - disable mitigations
sed -i 's/noinitrd/noinitrd mitigations=off/g' target/linux/x86/image/grub-efi.cfg

# Realtek Ethernet driver - R8168 & R8125 & R8126 & R8152 & R8101 & r8127
rm -rf package/kernel/{r8168,r8101,r8125,r8126,r8127}
git clone https://$github/sbwml/package_kernel_r8168 package/kernel/r8168
git clone https://$github/sbwml/package_kernel_r8101 package/kernel/r8101
git clone https://$github/sbwml/package_kernel_r8125 package/kernel/r8125
git clone https://$github/sbwml/package_kernel_r8126 package/kernel/r8126
git clone https://$github/sbwml/package_kernel_r8127 package/kernel/r8127
# Realtek Wireless driver - RTL8822CS & RTL8852AU
git clone https://$github/sbwml/package_kernel_rtl8822cs package/kernel/rtl8822cs
git clone https://$github/sbwml/package_kernel_rtl8852au package/kernel/rtl8852au

# GCC Optimization level -O3
curl -s $mirror/openwrt/patch/target-modify_for_aarch64_x86_64.patch | patch -p1

# libubox
sed -i '/TARGET_CFLAGS/ s/$/ -O2/' package/libs/libubox/Makefile

# DPDK & NUMACTL
mkdir -p package/emortal/{dpdk/patches,numactl}
curl -s $mirror/openwrt/patch/dpdk/dpdk/Makefile > package/emortal/dpdk/Makefile
curl -s $mirror/openwrt/patch/dpdk/dpdk/Config.in > package/emortal/dpdk/Config.in
curl -s $mirror/openwrt/patch/dpdk/dpdk/patches/010-dpdk_arm_build_platform_fix.patch > package/emortal/dpdk/patches/010-dpdk_arm_build_platform_fix.patch
curl -s $mirror/openwrt/patch/dpdk/dpdk/patches/201-r8125-add-r8125-ethernet-poll-mode-driver.patch > package/emortal/dpdk/patches/201-r8125-add-r8125-ethernet-poll-mode-driver.patch
curl -s $mirror/openwrt/patch/dpdk/numactl/Makefile > package/emortal/numactl/Makefile

# fstools
rm -rf package/system/fstools
git clone https://$github/sbwml/package_system_fstools -b openwrt-25.12 package/system/fstools
# util-linux
mkdir -p package/utils/util-linux/patches
curl -s https://raw.githubusercontent.com/sbwml/package_utils_util-linux/refs/heads/openwrt-25.12/patches/0001-ntfs-use-ntfs3-for-read-write-filesystem.patch > package/utils/util-linux/patches/0002-ntfs-use-ntfs3-for-read-write-filesystem.patch

# Shortcut Forwarding Engine
git clone https://$gitea/sbwml/shortcut-fe package/emortal/shortcut-fe

# Patch FireWall 4
rm -rf package/network/config/firewall4/patches
# firewall4
sed -i 's|$(PROJECT_GIT)/project|https://$github/openwrt|g' package/network/config/firewall4/Makefile
mkdir -p package/network/config/firewall4/patches
# fullcone
curl -s $mirror/openwrt/patch/firewall4/firewall4_patches/999-01-firewall4-add-fullcone-support.patch > package/network/config/firewall4/patches/999-01-firewall4-add-fullcone-support.patch
# bcm fullcone
curl -s $mirror/openwrt/patch/firewall4/firewall4_patches/999-02-firewall4-add-bcm-fullconenat-support.patch > package/network/config/firewall4/patches/999-02-firewall4-add-bcm-fullconenat-support.patch
# fix flow offload
curl -s $mirror/openwrt/patch/firewall4/firewall4_patches/001-fix-fw4-flow-offload.patch > package/network/config/firewall4/patches/001-fix-fw4-flow-offload.patch
# add custom nft command support
curl -s $mirror/openwrt/patch/firewall4/100-openwrt-firewall4-add-custom-nft-command-support.patch | patch -p1
# libnftnl
mkdir -p package/libs/libnftnl/patches
curl -s $mirror/openwrt/patch/firewall4/libnftnl/0001-libnftnl-add-fullcone-expression-support.patch > package/libs/libnftnl/patches/0001-libnftnl-add-fullcone-expression-support.patch
curl -s $mirror/openwrt/patch/firewall4/libnftnl/0002-libnftnl-add-brcm-fullcone-support.patch > package/libs/libnftnl/patches/0002-libnftnl-add-brcm-fullcone-support.patch
# fix build on rhel9
sed -i '/^PKG_BUILD_FLAGS[[:space:]]*:/aPKG_FIXUP:=autoreconf' package/libs/libnftnl/Makefile
# nftables
mkdir -p package/network/utils/nftables/patches
curl -s $mirror/openwrt/patch/firewall4/nftables/0001-nftables-add-fullcone-expression-support.patch > package/network/utils/nftables/patches/0001-nftables-add-fullcone-expression-support.patch
curl -s $mirror/openwrt/patch/firewall4/nftables/0002-nftables-add-brcm-fullconenat-support.patch > package/network/utils/nftables/patches/0002-nftables-add-brcm-fullconenat-support.patch

# FullCone module
# rm -rf package/network/utils/fullconenat-nft
# git clone https://$gitea/sbwml/nft-fullcone package/network/utils/fullconenat-nft

# IPv6 NAT
git clone https://$github/sbwml/packages_new_nat6 package/utils/nat6 -b openwrt-25.12

# natflow
git clone https://$github/sbwml/package_new_natflow package/utils/natflow

# luci-app-firewall
curl -s https://raw.githubusercontent.com/openwrt/luci/refs/heads/master/applications/luci-app-firewall/htdocs/luci-static/resources/view/firewall/zones.js > customfeeds/luci/applications/luci-app-firewall/htdocs/luci-static/resources/view/firewall/zones.js

# Patch Luci add nft_fullcone/bcm_fullcone & shortcut-fe & natflow & ipv6-nat & custom nft command option
pushd customfeeds/luci
    curl -s $mirror/openwrt/patch/firewall4/luci-25.12/0001-luci-app-firewall-add-nft-fullcone-and-bcm-fullcone-.patch | patch -p1
    curl -s $mirror/openwrt/patch/firewall4/luci-25.12/0002-luci-app-firewall-add-shortcut-fe-option.patch | patch -p1
    curl -s $mirror/openwrt/patch/firewall4/luci-25.12/0003-luci-app-firewall-add-ipv6-nat-option.patch | patch -p1
    curl -s $mirror/openwrt/patch/firewall4/luci-25.12/0004-luci-add-firewall-add-custom-nft-rule-support.patch | patch -p1
    curl -s $mirror/openwrt/patch/firewall4/luci-25.12/0005-luci-app-firewall-add-natflow-offload-support.patch | patch -p1
    curl -s $mirror/openwrt/patch/firewall4/luci-25.12/0006-luci-app-firewall-enable-hardware-offload-only-on-de.patch | patch -p1
    curl -s $mirror/openwrt/patch/firewall4/luci-25.12/0007-luci-app-firewall-add-fullcone6-option-for-nftables-.patch | patch -p1
popd

# openssl urandom
sed -i "/-openwrt/iOPENSSL_OPTIONS += enable-ktls '-DDEVRANDOM=\"\\\\\"/dev/urandom\\\\\"\"\'\n" package/libs/openssl/Makefile

# openssl - lto
sed -i "s/ no-lto//g" package/libs/openssl/Makefile
sed -i "/TARGET_CFLAGS +=/ s/\$/ -ffat-lto-objects/" package/libs/openssl/Makefile

# nghttp3
rm -rf customfeeds/packages/libs/nghttp3
git clone https://$github/sbwml/package_libs_nghttp3 customfeeds/packages/libs/nghttp3

# ngtcp2
rm -rf customfeeds/packages/libs/ngtcp2
git clone https://$github/sbwml/package_libs_ngtcp2 customfeeds/packages/libs/ngtcp2

# curl - fix passwall `time_pretransfer` check
rm -rf customfeeds/packages/net/curl
git clone https://$github/sbwml/feeds_packages_net_curl customfeeds/packages/net/curl

# procps-ng - top
sed -i 's/enable-skill/enable-skill --disable-modern-top/g' customfeeds/packages/utils/procps-ng/Makefile

# TTYD
sed -i 's/services/system/g' customfeeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i '3 a\\t\t"order": 50,' customfeeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g' customfeeds/packages/utils/ttyd/files/ttyd.init
sed -i 's/procd_set_param stderr 1/procd_set_param stderr 0/g' customfeeds/packages/utils/ttyd/files/ttyd.init

# UPnP
rm -rf customfeeds/packages/net/miniupnpd
git clone https://$gitea/sbwml/miniupnpd customfeeds/packages/net/miniupnpd -b v2.3.9
sed -i 's/PKG_RELEASE:=1/PKG_RELEASE:=3/g' customfeeds/packages/net/miniupnpd/Makefile

# nginx - latest version
rm -rf customfeeds/packages/net/nginx
git clone https://$github/sbwml/feeds_packages_net_nginx customfeeds/packages/net/nginx -b openwrt-25.12
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g;s/procd_set_param stderr 1/procd_set_param stderr 0/g' customfeeds/packages/net/nginx/files/nginx.init

# nginx - ubus
sed -i 's/ubus_parallel_req 2/ubus_parallel_req 6/g' customfeeds/packages/net/nginx/files-luci-support/60_nginx-luci-support
sed -i '/ubus_parallel_req/a\        ubus_script_timeout 300;' customfeeds/packages/net/nginx/files-luci-support/60_nginx-luci-support

# nginx - config
curl -s $mirror/openwrt/nginx/luci.locations > customfeeds/packages/net/nginx/files-luci-support/luci.locations
curl -s $mirror/openwrt/nginx/uci.conf.template > customfeeds/packages/net/nginx-util/files/uci.conf.template

# apk
mkdir -p package/system/apk/patches
curl -s $mirror/openwrt/patch/apk/9000-io_url_wget-disbale-hsts.patch > package/system/apk/patches/9000-io_url_wget-disbale-hsts.patch

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
curl -s $mirror/openwrt/patch/luci/0001-luci-mod-system-add-modal-overlay-dialog-to-reboot.patch | patch -p1
curl -s $mirror/openwrt/patch/luci/0002-luci-mod-status-displays-actual-process-memory-usage.patch | patch -p1
curl -s $mirror/openwrt/patch/luci/0003-luci-mod-status-storage-index-applicable-only-to-val.patch | patch -p1
curl -s $mirror/openwrt/patch/luci/0004-luci-mod-status-firewall-disable-legacy-firewall-rul.patch | patch -p1
curl -s $mirror/openwrt/patch/luci/0005-luci-mod-system-add-refresh-interval-setting.patch | patch -p1
curl -s $mirror/openwrt/patch/luci/0006-luci-mod-system-mounts-add-docker-directory-mount-po.patch | patch -p1
curl -s $mirror/openwrt/patch/luci/0007-luci-mod-system-add-ucitrack-luci-mod-system-zram.js.patch | patch -p1
popd

# Luci diagnostics.js
sed -i "s/immortalwrt.org/www.baidu.com/g" customfeeds/luci/modules/luci-mod-network/htdocs/luci-static/resources/view/network/diagnostics.js

# luci-compat - remove extra line breaks from description
sed -i '/<br \/>/d' customfeeds/luci/modules/luci-compat/luasrc/view/cbi/full_valuefooter.htm

# luci-app-package-manager
patch -p1 -d customfeeds/luci < ../data/luci/0001-luci-app-package-manager-support-installing-uploaded.patch

# profile
sed -i 's#\\u@\\h:\\w\\\$#\\[\\e[32;1m\\][\\u@\\h\\[\\e[0m\\] \\[\\033[01;34m\\]\\W\\[\\033[00m\\]\\[\\e[32;1m\\]]\\[\\e[0m\\]\\\$#g' package/base-files/files/etc/profile
sed -ri 's/(export PATH=")[^"]*/\1%PATH%:\/opt\/bin:\/opt\/sbin:\/opt\/usr\/bin:\/opt\/usr\/sbin/' package/base-files/files/etc/profile
sed -i '/PS1/a\export TERM=xterm-color' package/base-files/files/etc/profile

# rootfs files
mkdir -p files/etc/sysctl.d
curl -so files/etc/sysctl.d/10-default.conf $mirror/openwrt/files/etc/sysctl.d/10-default.conf
curl -so files/etc/sysctl.d/15-vm-swappiness.conf $mirror/openwrt/files/etc/sysctl.d/15-vm-swappiness.conf
curl -so files/etc/sysctl.d/16-udp-buffer-size.conf $mirror/openwrt/files/etc/sysctl.d/16-udp-buffer-size.conf

# luci-theme-bootstrap
sed -i 's/font-size: 13px/font-size: 14px/g' customfeeds/luci/themes/luci-theme-bootstrap/htdocs/luci-static/bootstrap/cascade.css
sed -i 's/9.75px/10.75px/g' customfeeds/luci/themes/luci-theme-bootstrap/htdocs/luci-static/bootstrap/cascade.css

# bpf-headers - 6.18
sed -ri "s/(PKG_PATCHVER:=)[^\"]*/\16.18/" package/kernel/bpf-headers/Makefile
curl -s $mirror/openwrt/patch/packages-patches/bpf-headers/900-fix-build.patch > package/kernel/bpf-headers/patches/900-fix-build.patch

# BBRv3 - linux-6.18
pushd target/linux/generic/backport-6.18
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0001-net-tcp_bbr-broaden-app-limited-rate-sample-detectio.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0002-net-tcp_bbr-v2-shrink-delivered_mstamp-first_tx_msta.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0003-net-tcp_bbr-v2-snapshot-packets-in-flight-at-transmi.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0004-net-tcp_bbr-v2-count-packets-lost-over-TCP-rate-samp.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0005-net-tcp_bbr-v2-export-FLAG_ECE-in-rate_sample.is_ece.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0006-net-tcp_bbr-v2-introduce-ca_ops-skb_marked_lost-CC-m.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0007-net-tcp_bbr-v2-adjust-skb-tx.in_flight-upon-merge-in.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0008-net-tcp_bbr-v2-adjust-skb-tx.in_flight-upon-split-in.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0009-net-tcp-add-new-ca-opts-flag-TCP_CONG_WANTS_CE_EVENT.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0010-net-tcp-re-generalize-TSO-sizing-in-TCP-CC-module-AP.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0011-net-tcp-add-fast_ack_mode-1-skip-rwin-check-in-tcp_f.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0012-net-tcp_bbr-v2-record-app-limited-status-of-TLP-repa.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0013-net-tcp_bbr-v2-inform-CC-module-of-losses-repaired-b.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0014-net-tcp_bbr-v2-introduce-is_acking_tlp_retrans_seq-i.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0015-tcp-introduce-per-route-feature-RTAX_FEATURE_ECN_LOW.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0016-net-tcp_bbr-v3-update-TCP-bbr-congestion-control-mod.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0017-net-tcp_bbr-v3-ensure-ECN-enabled-BBR-flows-set-ECT-.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0018-tcp-export-TCPI_OPT_ECN_LOW-in-tcp_info-tcpi_options.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0019-x86-cfi-bpf-Add-tso_segs-and-skb_marked_lost-to-bpf_.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/bbr3/010-bbr3-0020-net-tcp_bbr-v3-silence-Wconstant-logical-operand.patch
popd

# LRNG - 6.18
pushd target/linux/generic/hack-6.18
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0001-LRNG-Entropy-Source-and-DRNG-Manager.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0002-LRNG-allocate-one-DRNG-instance-per-NUMA-node.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0003-LRNG-proc-interface.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0004-LRNG-add-switchable-DRNG-support.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0005-LRNG-add-common-generic-hash-support.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0006-crypto-DRBG-externalize-DRBG-functions-for-LRNG.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0007-LRNG-add-SP800-90A-DRBG-extension.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0008-LRNG-add-kernel-crypto-API-PRNG-extension.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0009-LRNG-add-atomic-DRNG-implementation.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0010-LRNG-add-common-timer-based-entropy-source-code.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0011-LRNG-add-interrupt-entropy-source.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0012-scheduler-add-entropy-sampling-hook.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0013-LRNG-add-scheduler-based-entropy-source.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0014-LRNG-add-SP800-90B-compliant-health-tests.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0015-LRNG-add-random.c-entropy-source-support.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0016-LRNG-CPU-entropy-source.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0017-LRNG-add-Jitter-RNG-fast-noise-source.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0018-LRNG-add-option-to-enable-runtime-entropy-rate-confi.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0019-LRNG-add-interface-for-gathering-of-raw-entropy.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0020-LRNG-add-power-on-and-runtime-self-tests.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0021-LRNG-sysctls-and-proc-interface.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0022-LRMG-add-drop-in-replacement-random-4-API.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0023-LRNG-add-kernel-crypto-API-interface.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0024-LRNG-add-dev-lrng-device-file-support.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/lrng/011-LRNG-0025-LRNG-add-hwrand-framework-interface.patch
popd

# linux-rt - i915
pushd target/linux/generic/hack-6.18
    curl -Os $mirror/openwrt/patch/kernel-6.18/linux-rt/012-RT-0001-drm-i915-Use-preempt_disable-enable_rt-where-recomme.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/linux-rt/012-RT-0002-drm-i915-Don-t-disable-interrupts-on-PREEMPT_RT-duri.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/linux-rt/012-RT-0003-drm-i915-Disable-tracing-points-on-PREEMPT_RT.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/linux-rt/012-RT-0004-drm-i915-gt-Use-spin_lock_irq-instead-of-local_irq_d.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/linux-rt/012-RT-0005-drm-i915-Drop-the-irqs_disabled-check.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/linux-rt/012-RT-0006-drm-i915-guc-Consider-also-RCU-depth-in-busy-loop.patch
    curl -Os $mirror/openwrt/patch/kernel-6.18/linux-rt/012-RT-0007-Revert-drm-i915-Depend-on-PREEMPT_RT.patch
popd

# mac80211 - 6.18
rm -rf package/kernel/mac80211
git clone https://$github/sbwml/package_kernel_mac80211 package/kernel/mac80211 -b v6.18

# kernel patch
# btf: silence btf module warning messages
curl -s $mirror/openwrt/patch/kernel-6.18/btf/990-btf-silence-btf-module-warning-messages.patch > target/linux/generic/hack-6.18/990-btf-silence-btf-module-warning-messages.patch
# cpu model
curl -s $mirror/openwrt/patch/kernel-6.18/arm64/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch > target/linux/generic/hack-6.18/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch
# bcm-fullcone
curl -s $mirror/openwrt/patch/kernel-6.18/net/982-add-bcm-fullcone-support.patch > target/linux/generic/hack-6.18/982-add-bcm-fullcone-support.patch
curl -s $mirror/openwrt/patch/kernel-6.18/net/983-add-bcm-fullcone-nft_masq-support.patch > target/linux/generic/hack-6.18/983-add-bcm-fullcone-nft_masq-support.patch
# shortcut-fe
curl -s $mirror/openwrt/patch/kernel-6.18/net/601-netfilter-export-udp_get_timeouts-function.patch > target/linux/generic/hack-6.18/601-netfilter-export-udp_get_timeouts-function.patch
curl -s $mirror/openwrt/patch/kernel-6.18/net/952-net-conntrack-events-support-multiple-registrant.patch > target/linux/generic/hack-6.18/952-net-conntrack-events-support-multiple-registrant.patch
curl -s $mirror/openwrt/patch/kernel-6.18/net/953-net-patch-linux-kernel-to-support-shortcut-fe.patch > target/linux/generic/hack-6.18/953-net-patch-linux-kernel-to-support-shortcut-fe.patch
