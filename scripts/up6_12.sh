#!/bin/bash
# Set to local prepare

curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/kernel-6.12 > target/linux/generic/kernel-6.12


curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/bcm27xx/patches-6.12/950-0154-staging-vchiq_arm-Register-vcsm-cma-as-a-platform-dr.patch > target/linux/bcm27xx/patches-6.12/950-0154-staging-vchiq_arm-Register-vcsm-cma-as-a-platform-dr.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/bcm27xx/patches-6.12/950-0155-staging-vchiq_arm-Register-bcm2835-codec-as-a-platfo.patch > target/linux/bcm27xx/patches-6.12/950-0155-staging-vchiq_arm-Register-bcm2835-codec-as-a-platfo.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/bcm27xx/patches-6.12/950-0161-staging-vchiq_arm-Set-up-dma-ranges-on-child-devices.patch > target/linux/bcm27xx/patches-6.12/950-0161-staging-vchiq_arm-Set-up-dma-ranges-on-child-devices.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/bcm27xx/patches-6.12/950-0163-staging-vchiq-Load-bcm2835_isp-driver-from-vchiq.patch > target/linux/bcm27xx/patches-6.12/950-0163-staging-vchiq-Load-bcm2835_isp-driver-from-vchiq.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/bcm27xx/patches-6.12/950-0521-mm-vmscan-Maintain-TLB-coherency-in-LRU-code.patch > target/linux/bcm27xx/patches-6.12/950-0521-mm-vmscan-Maintain-TLB-coherency-in-LRU-code.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/backport-6.12/410-01-v6.14-mtd-rawnand-qcom-cleanup-qcom_nandc-driver.patch > target/linux/generic/backport-6.12/410-01-v6.14-mtd-rawnand-qcom-cleanup-qcom_nandc-driver.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/backport-6.12/410-02-v6.14-mtd-rawnand-qcom-Add-qcom-prefix-to-common-api.patch > target/linux/generic/backport-6.12/410-02-v6.14-mtd-rawnand-qcom-Add-qcom-prefix-to-common-api.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/backport-6.12/410-03-v6.14-mtd-nand-Add-qpic_common-API-file.patch > target/linux/generic/backport-6.12/410-03-v6.14-mtd-nand-Add-qpic_common-API-file.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/backport-6.12/410-04-v6.14-mtd-rawnand-qcom-use-FIELD_PREP-and-GENMASK.patch > target/linux/generic/backport-6.12/410-04-v6.14-mtd-rawnand-qcom-use-FIELD_PREP-and-GENMASK.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/backport-6.12/410-05-v6.14-mtd-rawnand-qcom-fix-broken-config-in-qcom_param_pag.patch > target/linux/generic/backport-6.12/410-05-v6.14-mtd-rawnand-qcom-fix-broken-config-in-qcom_param_pag.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/hack-6.12/259-regmap_dynamic.patch > target/linux/generic/hack-6.12/259-regmap_dynamic.patch

# rm -rf target/linux/generic/pending-6.12/680-net-fix-TCP-UDP-fraglist-GRO.patch
# rm -rf target/linux/generic/pending-6.12/802-nvmem-u-boot-env-align-endianness-of-crc32-values.patch