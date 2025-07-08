#!/bin/bash
# Set to local prepare

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

# routing - batman-adv fix build with linux-6.12
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/batman-adv/901-fix-linux-6.12rc2-builds.patch > customfeeds/routing/batman-adv/patches/901-fix-linux-6.12rc2-builds.patch

# libsodium - fix build with lto (GNU BUG - 89147)
sed -i "/CONFIGURE_ARGS/i\TARGET_CFLAGS += -ffat-lto-objects\n" customfeeds/packages/libs/libsodium/Makefile

# sms-tools
mkdir -p customfeeds/packages/utils/sms-tool/patches
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/sms-tools/900-fix-incompatible-pointer-type-error-for-signal-function.patch > customfeeds/packages/utils/sms-tool/patches/900-fix-incompatible-pointer-type-error-for-signal-function.patch



# 补丁
# https://github.com/openwrt/openwrt/commit/bb279e1a69b17d68d4cab299c4bb290a948b9930
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/package/network/services/hostapd/patches/030-Revert-nl80211-Accept-a-global-nl80211-event-to-a-br.patch > package/network/services/hostapd/patches/030-Revert-nl80211-Accept-a-global-nl80211-event-to-a-br.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/package/network/services/hostapd/patches/350-nl80211_del_beacon_bss.patch > package/network/services/hostapd/patches/350-nl80211_del_beacon_bss.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/package/network/services/hostapd/patches/370-preserve_radio_mask.patch > package/network/services/hostapd/patches/370-preserve_radio_mask.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/package/network/services/hostapd/patches/463-add-mcast_rate-to-11s.patch > package/network/services/hostapd/patches/463-add-mcast_rate-to-11s.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/package/network/services/hostapd/patches/601-ucode_support.patch > package/network/services/hostapd/patches/601-ucode_support.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/package/network/services/hostapd/patches/740-snoop_iface.patch > package/network/services/hostapd/patches/740-snoop_iface.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/package/network/services/hostapd/patches/780-Implement-APuP-Access-Point-Micro-Peering.patch > package/network/services/hostapd/patches/780-Implement-APuP-Access-Point-Micro-Peering.patch


# https://github.com/openwrt/openwrt/commit/77b9393d2f3609956a54a6e7d38bda8ddba6046a
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/package/utils/ucode/patches/102-ubus-add-exception_handler_set-function.patch > package/utils/ucode/patches/102-ubus-add-exception_handler_set-function.patch

sed -i \
-e 's/^PKG_VERSION:=1\.2\.8$/PKG_VERSION:=1.2.9/' \
-e 's/^PKG_HASH:=37fea5d6b5c9b08de7920d298de3cdc942e7ae64b1a3e8b880b2d390ae67ad95$/PKG_HASH:=e8c216255e129f26270639fee7775265665a31b11aa920253c3e5d5d62dfc4b8/' \
package/libs/libnftnl/Makefile

sed -i \
-e 's/PKG_VERSION:=1.1.1/PKG_VERSION:=1.1.3/' \
-e 's/PKG_HASH:=6358830f3a64f31e39b0ad421d7dadcd240b72343ded48d8ef13b8faf204865a/PKG_HASH:=9c8a64b59c90b0825e540a9b8fcb9d2d942c636f81ba50199f068fde44f34ed8/' \
package/network/utils/nftables/Makefile


curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/package/kernel/mt76/Makefile > package/kernel/mt76/Makefile
rm -rf package/kernel/mt76/patches/001-wifi-mt76-convert-platform-driver-.remove-to-.remove.patch
rm -rf package/kernel/mt76/patches/002-wifi-mt76-replace-strlcpy-with-strscpy.patch
rm -rf package/kernel/mt76/patches/003-wifi-mt76-link_id.patch