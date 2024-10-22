# Update FW4
# rm -rf package/network/config/firewall4
# cp -r $GITHUB_WORKSPACE/data/package/network/config/firewall4 package/network/config/firewall4

# Update iproute2
rm -rf package/network/utils/iproute2
pushd package/network/utils/
git clone --depth 1 https://github.com/sbwml/package_network_utils_iproute2 iproute2
popd

# Update GCC 13.3.0
rm -rf toolchain/gcc/*
pushd toolchain/gcc/
git clone --depth 1 https://github.com/immortalwrt/immortalwrt gcc && mv -n gcc/toolchain/gcc/* ./ ; rm -rf gcc
popd

# luci-app-turboacc
sed -i 's/kmod-tcp-bbr/kmod-tcp-bbr3/g' customfeeds/luci/applications/luci-app-turboacc/Makefile
 
# xdp-tools
cp -r $GITHUB_WORKSPACE/data/package/network/utils/xdp-tools package/network/utils/xdp-tools

# uqmi
rm -rf package/network/utils/uqmi
cp -r $GITHUB_WORKSPACE/data/package/network/utils/uqmi package/network/utils/uqmi

# tools: add upx tools
rm -rf tools/Makefile
cp -r $GITHUB_WORKSPACE/data/tools/upx tools/upx
cp -r $GITHUB_WORKSPACE/data/tools/Makefile tools/Makefile

# tools: add llvm/clang toolchain
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic/0001-tools-add-llvm-clang-toolchain.patch | patch -p1

# tools: add upx tools
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic/0002-tools-add-upx-tools.patch | patch -p1

# rootfs: upx compression
# include/rootfs.mk
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic/0003-rootfs-add-upx-compression-support.patch | patch -p1

# rootfs: add r/w (0600) permissions for UCI configuration files
# include/rootfs.mk
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic/0004-rootfs-add-r-w-permissions-for-UCI-configuration-fil.patch | patch -p1

# rootfs: Add support for local kmod installation sources
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic/0005-rootfs-Add-support-for-local-kmod-installation-sourc.patch | patch -p1

# BTF: fix failed to validate module
# config/Config-kernel.in patch
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic/0006-kernel-add-MODULE_ALLOW_BTF_MISMATCH-option.patch | patch -p1

# kernel: Add support for llvm/clang compiler
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic/0007-kernel-Add-support-for-llvm-clang-compiler.patch | patch -p1

# toolchain: Add libquadmath to the toolchain
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic/0008-libquadmath-Add-libquadmath-to-the-toolchain.patch | patch -p1

# build: kernel: add out-of-tree kernel config
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic/0009-build-kernel-add-out-of-tree-kernel-config.patch | patch -p1

# kernel: linux-6.11 config
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic/0010-include-kernel-add-miss-config-for-linux-6.11.patch | patch -p1

# meson: add platform variable to cross-compilation file
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/generic/0011-meson-add-platform-variable-to-cross-compilation-fil.patch | patch -p1

# dwarves 1.25
rm -rf tools/dwarves
git clone https://github.com/sbwml/tools_dwarves tools/dwarves

# x86 - disable intel_pstate & mitigations
sed -i 's/noinitrd/noinitrd intel_pstate=disable mitigations=off/g' target/linux/x86/image/grub-efi.cfg

# Use nginx instead of uhttpd
sed -i 's/+uhttpd /+luci-nginx /g' customfeeds/luci/collections/luci/Makefile
sed -i 's/+uhttpd-mod-ubus //' customfeeds/luci/collections/luci/Makefile
sed -i 's/+uhttpd /+luci-nginx /g' customfeeds/luci/collections/luci-light/Makefile
sed -i "s/+luci /+luci-nginx /g" customfeeds/luci/collections/luci-ssl-openssl/Makefile
sed -i "s/+luci /+luci-nginx /g" customfeeds/luci/collections/luci-ssl/Makefile
sed -i 's/+uhttpd +uhttpd-mod-ubus /+luci-nginx /g' customfeeds/packages/net/wg-installer/Makefile
sed -i '/uhttpd-mod-ubus/d' customfeeds/luci/collections/luci-light/Makefile
sed -i 's/+luci-nginx \\$/+luci-nginx/' customfeeds/luci/collections/luci-light/Makefile

# Realtek driver - R8168 & R8125 & R8126 & R8152 & R8101
rm -rf package/kernel/r8168 package/kernel/r8101 package/kernel/r8125 package/kernel/r8126
git clone https://github.com/sbwml/package_kernel_r8168 package/kernel/r8168
git clone https://github.com/sbwml/package_kernel_r8152 package/kernel/r8152
git clone https://github.com/sbwml/package_kernel_r8101 package/kernel/r8101
git clone https://github.com/sbwml/package_kernel_r8125 package/kernel/r8125
git clone https://github.com/sbwml/package_kernel_r8126 package/kernel/r8126

# GCC Optimization level -O3
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/target-modify_for_x86_64.patch | patch -p1

# Patch FireWall 4
# firewall4 - master
rm -rf package/network/config/firewall4
cp -r $GITHUB_WORKSPACE/data/openwrt/package/network/config/firewall4 package/network/config/firewall4
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
cp -r $GITHUB_WORKSPACE/data/openwrt/package/libs/libnftnl package/libs/libnftnl
mkdir -p package/libs/libnftnl/patches
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/libnftnl/001-libnftnl-add-fullcone-expression-support.patch > package/libs/libnftnl/patches/001-libnftnl-add-fullcone-expression-support.patch
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/libnftnl/002-libnftnl-add-brcm-fullcone-support.patch > package/libs/libnftnl/patches/002-libnftnl-add-brcm-fullcone-support.patch
sed -i '/PKG_INSTALL:=1/iPKG_FIXUP:=autoreconf' package/libs/libnftnl/Makefile
# nftables
rm -rf package/network/utils/nftables
cp -r $GITHUB_WORKSPACE/data/openwrt/package/network/utils/nftables package/network/utils/nftables
mkdir -p package/network/utils/nftables/patches
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/nftables/002-nftables-add-fullcone-expression-support.patch > package/network/utils/nftables/patches/002-nftables-add-fullcone-expression-support.patch
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/nftables/003-nftables-add-brcm-fullconenat-support.patch > package/network/utils/nftables/patches/003-nftables-add-brcm-fullconenat-support.patch
# hide nftables warning message
pushd customfeeds/luci
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/luci/0004-luci-mod-status-firewall-disable-legacy-firewall-rul.patch | patch -p1
popd

# FullCone module
git clone https://git.cooluc.com/sbwml/nft-fullcone package/new/nft-fullcone

# IPv6 NAT
git clone https://github.com/sbwml/packages_new_nat6 package/new/nat6

# natflow
git clone https://github.com/sbwml/package_new_natflow package/new/natflow

# Patch Luci add nft_fullcone/bcm_fullcone & shortcut-fe & natflow & ipv6-nat & custom nft command option
pushd customfeeds/luci
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/0001-luci-app-firewall-add-nft-fullcone-and-bcm-fullcone-.patch | patch -p1
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/0002-luci-app-firewall-add-shortcut-fe-option.patch | patch -p1
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/0003-luci-app-firewall-add-ipv6-nat-option.patch | patch -p1
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/0004-luci-add-firewall-add-custom-nft-rule-support.patch | patch -p1
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/0005-luci-app-firewall-add-natflow-offload-support.patch | patch -p1
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/firewall4/0400-luci-app-firewall-drop-bcm-fullcone.patch | patch -p1
popd

# nghttp3
rm -rf customfeeds/packages/libs/nghttp3
git clone https://github.com/sbwml/package_libs_nghttp3 package/libs/nghttp3

# ngtcp2
rm -rf customfeeds/packages/libs/ngtcp2
git clone https://github.com/sbwml/package_libs_ngtcp2 package/libs/ngtcp2

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

rm -rf customfeeds/packages/utils/docker-compose
cp -r $GITHUB_WORKSPACE/data/packages-master/utils/docker-compose customfeeds/packages/utils/docker-compose

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
rm -rf customfeeds/packages/utils/procps-ng
cp -r $GITHUB_WORKSPACE/data/packages-master/utils/procps-ng customfeeds/packages/utils/procps-ng
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

# opkg
mkdir -p package/system/opkg/patches
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/opkg/900-opkg-download-disable-hsts.patch > package/system/opkg/patches/900-opkg-download-disable-hsts.patch

# uwsgi - bump version
rm -rf customfeeds/packages/net/uwsgi
cp -r $GITHUB_WORKSPACE/data/packages-master/net/uwsgi customfeeds/packages/net/uwsgi

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
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/luci/0003-luci-mod-status-storage-index-applicable-only-to-val.patch | patch -p1
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/luci/0004-luci-mod-status-firewall-disable-legacy-firewall-rul.patch | patch -p1
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/luci/0005-luci-mod-system-add-refresh-interval-setting.patch | patch -p1
popd

# Luci diagnostics.js
sed -i "s/openwrt.org/www.baidu.com/g" customfeeds/luci/modules/luci-mod-network/htdocs/luci-static/resources/view/network/diagnostics.js

# luci - drop ethernet port status
# rm -f customfeeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/29_ports.js

# luci - rollback dhcp.js
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/luci/dhcp/openwrt-23.05-dhcp.js > customfeeds/luci/modules/luci-mod-network/htdocs/luci-static/resources/view/network/dhcp.js

# ppp - 2.5.0
# rm -rf package/network/services/ppp
# git clone https://github.com/sbwml/package_network_services_ppp package/network/services/ppp

# odhcpd RFC-9096
mkdir -p package/network/services/odhcpd/patches
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/odhcpd/001-odhcpd-RFC-9096-compliance.patch > package/network/services/odhcpd/patches/001-odhcpd-RFC-9096-compliance.patch
pushd customfeeds/luci
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/odhcpd/luci-mod-network-add-option-for-ipv6-max-plt-vlt.patch | patch -p1
popd

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
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/btf/990-btf-silence-btf-module-warning-messages.patch > target/linux/generic/hack-6.6/990-btf-silence-btf-module-warning-messages.patch
# cpu model
# curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/arm64/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch > target/linux/generic/pending-6.6/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch
# fullcone
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/net/952-net-conntrack-events-support-multiple-registrant.patch > target/linux/generic/hack-6.6/952-net-conntrack-events-support-multiple-registrant.patch
# bcm-fullcone
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/net/982-add-bcm-fullcone-support.patch > target/linux/generic/hack-6.6/982-add-bcm-fullcone-support.patch
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/net/983-add-bcm-fullcone-nft_masq-support.patch > target/linux/generic/hack-6.6/983-add-bcm-fullcone-nft_masq-support.patch
# shortcut-fe
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/net/601-netfilter-export-udp_get_timeouts-function.patch > target/linux/generic/hack-6.6/601-netfilter-export-udp_get_timeouts-function.patch
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/net/953-net-patch-linux-kernel-to-support-shortcut-fe.patch > target/linux/generic/hack-6.6/953-net-patch-linux-kernel-to-support-shortcut-fe.patch
# backport - 6.8 fast-path-variables
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/backport/901-v6.8-cache-enforce-cache-groups.patch > target/linux/generic/backport-6.6/901-v6.8-cache-enforce-cache-groups.patch
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/backport/902-v6.8-netns-ipv4-reorganize-netns_ipv4-fast-path-variables.patch > target/linux/generic/backport-6.6/902-v6.8-netns-ipv4-reorganize-netns_ipv4-fast-path-variables.patch
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/backport/903-v6.8-net-device-reorganize-net_device-fast-path-variables.patch > target/linux/generic/backport-6.6/903-v6.8-net-device-reorganize-net_device-fast-path-variables.patch
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/backport/904-v6.8-tcp-reorganize-tcp_sock-fast-path-variables.patch > target/linux/generic/backport-6.6/904-v6.8-tcp-reorganize-tcp_sock-fast-path-variables.patch
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/kernel-6.6/backport/905-v6.8-tcp-move-tp-scaling_ratio-to-tcp_sock_read_txrx-grou.patch > target/linux/generic/backport-6.6/905-v6.8-tcp-move-tp-scaling_ratio-to-tcp_sock_read_txrx-grou.patch

# nat46
mkdir -p package/kernel/nat46/patches
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/nat46/100-fix-build-with-kernel-6.9.patch > package/kernel/nat46/patches/100-fix-build-with-kernel-6.9.patch
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/nat46/101-fix-build-with-kernel-6.12.patch > package/kernel/nat46/patches/101-fix-build-with-kernel-6.12.patch

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

# irqbalance: disable build with numa
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/irqbalance/011-meson-numa.patch > customfeeds/packages/utils/irqbalance/patches/011-meson-numa.patch
sed -i '/-Dcapng=disabled/i\\t-Dnuma=disabled \\' customfeeds/packages/utils/irqbalance/Makefile
