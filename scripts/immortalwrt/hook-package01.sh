#!/bin/bash
# Set to local prepare

# rtpengine
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/rtpengine/900-fix-linux-6.12-11.5.1.18.patch > customfeeds/telephony/net/rtpengine/patches/900-fix-linux-6.12-11.5.1.18.patch

# routing - batman-adv fix build with linux-6.12
curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/refs/heads/master/openwrt/patch/packages-patches/batman-adv/901-fix-linux-6.12rc2-builds.patch > customfeeds/routing/batman-adv/patches/901-fix-linux-6.12rc2-builds.patch

# libxcrypt
sed -i "/CONFIGURE_ARGS/i\TARGET_CFLAGS += -Wno-error=pedantic\n" package/libs/xcrypt/libxcrypt/Makefile

rm -rf target/linux/rockchip/patches-6.12/036-01-v6.15-scsi-ufs-core-Export-ufshcd_dme_reset-and.patch
rm -rf target/linux/rockchip/patches-6.12/036-02-v6.15-scsi-ufs-rockchip-Initial-support-for-UFS.patch
rm -rf target/linux/rockchip/patches-6.12/036-03-v6.15-scsi-ufs-rockchip-Fix-devm_clk_bulk_get_all_enabled.patch

curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/rockchip/patches-6.12/037-01-v6.15-scsi-ufs-core-Export-ufshcd_dme_reset-and.patch > target/linux/rockchip/patches-6.12/037-01-v6.15-scsi-ufs-core-Export-ufshcd_dme_reset-and.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/rockchip/patches-6.12/037-02-v6.15-scsi-ufs-rockchip-Initial-support-for-UFS.patch > target/linux/rockchip/patches-6.12/037-02-v6.15-scsi-ufs-rockchip-Initial-support-for-UFS.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/rockchip/patches-6.12/037-03-v6.15-scsi-ufs-rockchip-Fix-devm_clk_bulk_get_all_enabled.patch > target/linux/rockchip/patches-6.12/037-03-v6.15-scsi-ufs-rockchip-Fix-devm_clk_bulk_get_all_enabled.patch