#!/bin/bash
# Set to local prepare

curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/include/kernel-6.6 > include/kernel-6.6
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/bcm27xx/patches-6.6/950-0025-drm-atomic-helpers-remove-legacy_cursor_update-hacks.patch > target/linux/bcm27xx/patches-6.6/950-0025-drm-atomic-helpers-remove-legacy_cursor_update-hacks.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/bcm27xx/patches-6.6/950-0169-hid-usb-Add-device-quirks-for-Freeway-Airmouse-T3-an.patch > target/linux/bcm27xx/patches-6.6/950-0169-hid-usb-Add-device-quirks-for-Freeway-Airmouse-T3-an.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/bcm27xx/patches-6.6/950-0923-drm-Add-DRM_MODE_TV_MODE_MONOCHROME.patch > target/linux/bcm27xx/patches-6.6/950-0923-drm-Add-DRM_MODE_TV_MODE_MONOCHROME.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/bcm27xx/patches-6.6/950-1051-drm-panel-Add-and-initialise-an-orientation-field-to.patch > target/linux/bcm27xx/patches-6.6/950-1051-drm-panel-Add-and-initialise-an-orientation-field-to.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/generic/backport-6.6/896-01-v6.9-net-dsa-mv88e6xxx-rename-mv88e6xxx_g2_scratch_gpio_s.patch > target/linux/generic/backport-6.6/896-01-v6.9-net-dsa-mv88e6xxx-rename-mv88e6xxx_g2_scratch_gpio_s.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/generic/backport-6.6/896-02-v6.9-net-dsa-mv88e6xxx-add-Amethyst-specific-SMI-GPIO-fun.patch > target/linux/generic/backport-6.6/896-02-v6.9-net-dsa-mv88e6xxx-add-Amethyst-specific-SMI-GPIO-fun.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/generic/backport-6.6/901-v6.13-net-dsa-mv88e6xxx-Support-LED-control.patch > target/linux/generic/backport-6.6/901-v6.13-net-dsa-mv88e6xxx-Support-LED-control.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/generic/hack-6.6/711-net-dsa-mv88e6xxx-disable-ATU-violation.patch > target/linux/generic/hack-6.6/711-net-dsa-mv88e6xxx-disable-ATU-violation.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/generic/hack-6.6/904-debloat_dma_buf.patch > target/linux/generic/hack-6.6/904-debloat_dma_buf.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/generic/pending-6.6/701-netfilter-nf_tables-ignore-EOPNOTSUPP-on-flowtable-d.patch > target/linux/generic/pending-6.6/701-netfilter-nf_tables-ignore-EOPNOTSUPP-on-flowtable-d.patch


curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/bcm27xx/patches-6.6/950-0464-drm-v3d-New-debugfs-end-points-to-query-GPU-usage-st.patch > target/linux/bcm27xx/patches-6.6/950-0464-drm-v3d-New-debugfs-end-points-to-query-GPU-usage-st.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/bcm27xx/patches-6.6/950-0555-drm-v3d-fix-up-register-addresses-for-V3D-7.x.patch > target/linux/bcm27xx/patches-6.6/950-0555-drm-v3d-fix-up-register-addresses-for-V3D-7.x.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/bcm27xx/patches-6.6/950-1512-dts-bcm2711-Don-t-mark-timer-regs-unconfigured.patch > target/linux/bcm27xx/patches-6.6/950-1512-dts-bcm2711-Don-t-mark-timer-regs-unconfigured.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/generic/pending-6.6/670-ipv6-allow-rejecting-with-source-address-failed-policy.patch > target/linux/generic/pending-6.6/670-ipv6-allow-rejecting-with-source-address-failed-policy.patch



rm -rf target/linux/bcm27xx/patches-6.6/950-1498-dts-bcm2711-PL011-UARTs-are-actually-r1p5.patch
rm -rf target/linux/bcm27xx/patches-6.6/950-1551-drm-v3d-Don-t-run-jobs-that-have-errors-flagged-in-i.patch