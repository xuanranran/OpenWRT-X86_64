#!/bin/bash
# Set to local prepare

curl -s https://raw.githubusercontent.com/EPinci/openwrt/refs/heads/kernel-6.12.52/target/linux/generic/kernel-6.12 > target/linux/generic/kernel-6.12

rm -rf target/linux/generic/backport-6.12/541-v6.18-ksmbd-add-max-ip-connections-parameter.patch

curl -s https://raw.githubusercontent.com/EPinci/openwrt/refs/heads/kernel-6.12.52/target/linux/bcm27xx/patches-6.12/950-0322-Bluetooth-hci_sync-Add-fallback-bd-address-prop.patch > target/linux/bcm27xx/patches-6.12/950-0322-Bluetooth-hci_sync-Add-fallback-bd-address-prop.patch
curl -s https://raw.githubusercontent.com/EPinci/openwrt/refs/heads/kernel-6.12.52/target/linux/bcm27xx/patches-6.12/950-0335-usb-xhci-add-XHCI_VLI_HUB_TT_QUIRK.patch > target/linux/bcm27xx/patches-6.12/950-0335-usb-xhci-add-XHCI_VLI_HUB_TT_QUIRK.patch
curl -s https://raw.githubusercontent.com/EPinci/openwrt/refs/heads/kernel-6.12.52/target/linux/bcm27xx/patches-6.12/950-0502-Bluetooth-hci_sync-Fix-crash-on-NULL-parent.patch > target/linux/bcm27xx/patches-6.12/950-0502-Bluetooth-hci_sync-Fix-crash-on-NULL-parent.patch
curl -s https://raw.githubusercontent.com/EPinci/openwrt/refs/heads/kernel-6.12.52/target/linux/econet/patches-6.12/902-snand-mtk-bmt-support.patch > target/linux/econet/patches-6.12/902-snand-mtk-bmt-support.patch
curl -s https://raw.githubusercontent.com/EPinci/openwrt/refs/heads/kernel-6.12.52/target/linux/generic/hack-6.12/253-ksmbd-config.patch > target/linux/generic/hack-6.12/253-ksmbd-config.patch
curl -s https://raw.githubusercontent.com/EPinci/openwrt/refs/heads/kernel-6.12.52/target/linux/generic/pending-6.12/203-kallsyms_uncompressed.patch > target/linux/generic/pending-6.12/203-kallsyms_uncompressed.patch
curl -s https://raw.githubusercontent.com/EPinci/openwrt/refs/heads/kernel-6.12.52/target/linux/generic/pending-6.12/920-mangle_bootargs.patch > target/linux/generic/pending-6.12/920-mangle_bootargs.patch
curl -s https://raw.githubusercontent.com/EPinci/openwrt/refs/heads/kernel-6.12.52/target/linux/mediatek/patches-6.12/320-hwrng-add-driver-for-MediaTek-TRNG-SMC.patch > target/linux/mediatek/patches-6.12/320-hwrng-add-driver-for-MediaTek-TRNG-SMC.patch
curl -s https://raw.githubusercontent.com/EPinci/openwrt/refs/heads/kernel-6.12.52/target/linux/qualcommax/patches-6.12/0804-remoteproc-qcom-q6v5-Add-multipd-interrupts-support.patch > target/linux/qualcommax/patches-6.12/0804-remoteproc-qcom-q6v5-Add-multipd-interrupts-support.patch
curl -s https://raw.githubusercontent.com/EPinci/openwrt/refs/heads/kernel-6.12.52/target/linux/rockchip/patches-6.12/031-06-v6.15-hwrng-rockchip-add-support-for-rk3588-s-standalone-T.patch > target/linux/rockchip/patches-6.12/031-06-v6.15-hwrng-rockchip-add-support-for-rk3588-s-standalone-T.patch
curl -s https://raw.githubusercontent.com/EPinci/openwrt/refs/heads/kernel-6.12.52/target/linux/rockchip/patches-6.12/036-05-v6.14-phy-rockchip-naneng-combo-add-rk3576-support.patch > target/linux/rockchip/patches-6.12/036-05-v6.14-phy-rockchip-naneng-combo-add-rk3576-support.patch
curl -s https://raw.githubusercontent.com/EPinci/openwrt/refs/heads/kernel-6.12.52/target/linux/starfive/patches-6.12/1015-hwrng-Add-StarFive-JH7100-Random-Number-Generator-dr.patch > target/linux/starfive/patches-6.12/1015-hwrng-Add-StarFive-JH7100-Random-Number-Generator-dr.patch