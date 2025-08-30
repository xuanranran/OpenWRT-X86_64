#!/bin/bash
# Set to local prepare

curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/kernel-6.12 > target/linux/generic/kernel-6.12

rm -rf target/linux/generic/backport-6.12/220-v6.16-powerpc-boot-fix-build-with-gcc-15.patch
rm -rf target/linux/imx/patches-6.12/506-pending-PCI-imx6-Remove-apps_reset-toggle-in-_core_reset-function.patch


curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/bcm27xx/patches-6.12/950-0124-usb-add-plumbing-for-updating-interrupt-endpoint-int.patch > target/linux/bcm27xx/patches-6.12/950-0124-usb-add-plumbing-for-updating-interrupt-endpoint-int.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/bcm27xx/patches-6.12/950-0125-xhci-implement-xhci_fixup_endpoint-for-interval-adju.patch > target/linux/bcm27xx/patches-6.12/950-0125-xhci-implement-xhci_fixup_endpoint-for-interval-adju.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/bcm27xx/patches-6.12/950-0335-usb-xhci-add-XHCI_VLI_HUB_TT_QUIRK.patch > target/linux/bcm27xx/patches-6.12/950-0335-usb-xhci-add-XHCI_VLI_HUB_TT_QUIRK.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/bcm27xx/patches-6.12/950-0364-drm-Add-RP1-DSI-driver.patch > target/linux/bcm27xx/patches-6.12/950-0364-drm-Add-RP1-DSI-driver.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/bcm27xx/patches-6.12/950-0480-media-pisp_be-Re-introduce-multi-context-support.patch > target/linux/bcm27xx/patches-6.12/950-0480-media-pisp_be-Re-introduce-multi-context-support.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/bcm27xx/patches-6.12/950-0950-usb-xhci-default-to-Intel-scheme-for-calculating-U1-.patch > target/linux/bcm27xx/patches-6.12/950-0950-usb-xhci-default-to-Intel-scheme-for-calculating-U1-.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/backport-6.12/620-v6.15-ppp-use-IFF_NO_QUEUE-in-virtual-interfaces.patch > target/linux/generic/backport-6.12/620-v6.15-ppp-use-IFF_NO_QUEUE-in-virtual-interfaces.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/backport-6.12/720-09-v6.14-net-phy-Constify-struct-mdio_device_id.patch > target/linux/generic/backport-6.12/720-09-v6.14-net-phy-Constify-struct-mdio_device_id.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/hack-6.12/721-net-add-packet-mangeling.patch > target/linux/generic/hack-6.12/721-net-add-packet-mangeling.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/pending-6.12/100-compiler.h-only-include-asm-rwonce.h-for-kernel-code.patch > target/linux/generic/pending-6.12/100-compiler.h-only-include-asm-rwonce.h-for-kernel-code.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/pending-6.12/487-mtd-spinand-Add-support-for-Etron-EM73D044VCx.patch > target/linux/generic/pending-6.12/487-mtd-spinand-Add-support-for-Etron-EM73D044VCx.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/pending-6.12/736-04-net-ethernet-mediatek-fix-ppe-flow-accounting-for-L2.patch > target/linux/generic/pending-6.12/736-04-net-ethernet-mediatek-fix-ppe-flow-accounting-for-L2.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/pending-6.12/790-bus-mhi-core-add-SBL-state-callback.patch > target/linux/generic/pending-6.12/790-bus-mhi-core-add-SBL-state-callback.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/imx/patches-6.12/506-6.16-PCI-imx6-Skip-link-up-workaround-for-newer-platforms.patch > target/linux/imx/patches-6.12/506-6.16-PCI-imx6-Skip-link-up-workaround-for-newer-platforms.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/ipq40xx/patches-6.12/999-atm-mpoa-intel-dsl-phy-support.patch > target/linux/ipq40xx/patches-6.12/999-atm-mpoa-intel-dsl-phy-support.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/mediatek/patches-6.12/121-hack-spi-nand-1b-bbm.patch > target/linux/mediatek/patches-6.12/121-hack-spi-nand-1b-bbm.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/mediatek/patches-6.12/330-snand-mtk-bmt-support.patch > target/linux/mediatek/patches-6.12/330-snand-mtk-bmt-support.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/mediatek/patches-6.12/340-mtd-spinand-Add-support-for-the-Fidelix-FM35X1GA.patch > target/linux/mediatek/patches-6.12/340-mtd-spinand-Add-support-for-the-Fidelix-FM35X1GA.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/mediatek/patches-6.12/410-bt-mtk-serial-fix.patch > target/linux/mediatek/patches-6.12/410-bt-mtk-serial-fix.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/mediatek/patches-6.12/435-drivers-mtd-spinand-Add-calibration-support-for-spin.patch > target/linux/mediatek/patches-6.12/435-drivers-mtd-spinand-Add-calibration-support-for-spin.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/mediatek/patches-6.12/436-drivers-mtd-spi-nor-Add-calibration-support-for-spi-.patch > target/linux/mediatek/patches-6.12/436-drivers-mtd-spi-nor-Add-calibration-support-for-spi-.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/mediatek/patches-6.12/960-asus-hack-u-boot-ignore-mtdparts.patch > target/linux/mediatek/patches-6.12/960-asus-hack-u-boot-ignore-mtdparts.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/qualcommax/patches-6.12/0812-soc-qcom-mdt_loader-support-MPD.patch > target/linux/qualcommax/patches-6.12/0812-soc-qcom-mdt_loader-support-MPD.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/starfive/patches-6.12/0009-uart-8250-Add-dw-auto-flow-ctrl-support.patch > target/linux/starfive/patches-6.12/0009-uart-8250-Add-dw-auto-flow-ctrl-support.patch