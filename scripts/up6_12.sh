#!/bin/bash
# Set to local prepare

curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/kernel-6.12 > target/linux/generic/kernel-6.12

curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/ath79/patches-6.12/900-unaligned_access_hacks.patch > target/linux/ath79/patches-6.12/900-unaligned_access_hacks.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/bcm27xx/patches-6.12/950-0154-staging-vchiq_arm-Register-vcsm-cma-as-a-platform-dr.patch > target/linux/bcm27xx/patches-6.12/950-0154-staging-vchiq_arm-Register-vcsm-cma-as-a-platform-dr.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/bcm27xx/patches-6.12/950-0155-staging-vchiq_arm-Register-bcm2835-codec-as-a-platfo.patch > target/linux/bcm27xx/patches-6.12/950-0155-staging-vchiq_arm-Register-bcm2835-codec-as-a-platfo.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/bcm27xx/patches-6.12/950-0161-staging-vchiq_arm-Set-up-dma-ranges-on-child-devices.patch > target/linux/bcm27xx/patches-6.12/950-0161-staging-vchiq_arm-Set-up-dma-ranges-on-child-devices.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/bcm27xx/patches-6.12/950-0163-staging-vchiq-Load-bcm2835_isp-driver-from-vchiq.patch > target/linux/bcm27xx/patches-6.12/950-0163-staging-vchiq-Load-bcm2835_isp-driver-from-vchiq.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/bcm27xx/patches-6.12/950-0196-staging-fbtft-Add-support-for-display-variants.patch > target/linux/bcm27xx/patches-6.12/950-0196-staging-fbtft-Add-support-for-display-variants.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/bcm27xx/patches-6.12/950-0330-pps-Compatibility-hack-should-be-X86-specific.patch > target/linux/bcm27xx/patches-6.12/950-0330-pps-Compatibility-hack-should-be-X86-specific.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/bcm27xx/patches-6.12/950-0521-mm-vmscan-Maintain-TLB-coherency-in-LRU-code.patch > target/linux/bcm27xx/patches-6.12/950-0521-mm-vmscan-Maintain-TLB-coherency-in-LRU-code.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/backport-6.12/410-01-v6.14-mtd-rawnand-qcom-cleanup-qcom_nandc-driver.patch > target/linux/generic/backport-6.12/410-01-v6.14-mtd-rawnand-qcom-cleanup-qcom_nandc-driver.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/backport-6.12/410-02-v6.14-mtd-rawnand-qcom-Add-qcom-prefix-to-common-api.patch > target/linux/generic/backport-6.12/410-02-v6.14-mtd-rawnand-qcom-Add-qcom-prefix-to-common-api.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/backport-6.12/410-03-v6.14-mtd-nand-Add-qpic_common-API-file.patch > target/linux/generic/backport-6.12/410-03-v6.14-mtd-nand-Add-qpic_common-API-file.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/backport-6.12/410-04-v6.14-mtd-rawnand-qcom-use-FIELD_PREP-and-GENMASK.patch > target/linux/generic/backport-6.12/410-04-v6.14-mtd-rawnand-qcom-use-FIELD_PREP-and-GENMASK.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/backport-6.12/410-05-v6.14-mtd-rawnand-qcom-fix-broken-config-in-qcom_param_pag.patch > target/linux/generic/backport-6.12/410-05-v6.14-mtd-rawnand-qcom-fix-broken-config-in-qcom_param_pag.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/backport-6.12/620-v6.15-ppp-use-IFF_NO_QUEUE-in-virtual-interfaces.patch > target/linux/generic/backport-6.12/620-v6.15-ppp-use-IFF_NO_QUEUE-in-virtual-interfaces.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/hack-6.12/259-regmap_dynamic.patch > target/linux/generic/hack-6.12/259-regmap_dynamic.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/hack-6.12/721-net-add-packet-mangeling.patch > target/linux/generic/hack-6.12/721-net-add-packet-mangeling.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/pending-6.12/650-net-pppoe-implement-GRO-support.patch > target/linux/generic/pending-6.12/650-net-pppoe-implement-GRO-support.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/pending-6.12/655-increase_skb_pad.patch > target/linux/generic/pending-6.12/655-increase_skb_pad.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/pending-6.12/670-ipv6-allow-rejecting-with-source-address-failed-policy.patch > target/linux/generic/pending-6.12/670-ipv6-allow-rejecting-with-source-address-failed-policy.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/generic/pending-6.12/701-netfilter-nf_tables-ignore-EOPNOTSUPP-on-flowtable-d.patch > target/linux/generic/pending-6.12/701-netfilter-nf_tables-ignore-EOPNOTSUPP-on-flowtable-d.patch
curl -s https://raw.githubusercontent.com/graysky2/openwrt/refs/heads/6/target/linux/ipq40xx/patches-6.12/701-net-dsa-add-out-of-band-tagging-protocol.patch > target/linux/ipq40xx/patches-6.12/701-net-dsa-add-out-of-band-tagging-protocol.patch

sed -i '/^# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set$/a CONFIG_VHOST_ENABLE_FORK_OWNER_CONTROL=y' target/linux/generic/config-6.12

# rm -rf target/linux/generic/pending-6.12/680-net-fix-TCP-UDP-fraglist-GRO.patch
# rm -rf target/linux/generic/pending-6.12/802-nvmem-u-boot-env-align-endianness-of-crc32-values.patch