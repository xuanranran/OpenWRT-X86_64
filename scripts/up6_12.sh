#!/bin/bash
# Set to local prepare

# curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/generic/kernel-6.12 > target/linux/generic/kernel-6.12



curl -s https://raw.githubusercontent.com/leobsky/openwrt/refs/heads/6.6.100/6.12.40/target/linux/generic/kernel-6.12 > target/linux/generic/kernel-6.12

curl -s https://raw.githubusercontent.com/leobsky/openwrt/refs/heads/6.6.100/6.12.40/target/linux/bcm27xx/patches-6.12/950-0054-Add-dwc_otg-driver.patch > target/linux/bcm27xx/patches-6.12/950-0054-Add-dwc_otg-driver.patch
curl -s https://raw.githubusercontent.com/leobsky/openwrt/refs/heads/6.6.100/6.12.40/target/linux/bcm27xx/patches-6.12/950-0154-staging-vchiq_arm-Register-vcsm-cma-as-a-platform-dr.patch > target/linux/bcm27xx/patches-6.12/950-0154-staging-vchiq_arm-Register-vcsm-cma-as-a-platform-dr.patch
curl -s https://raw.githubusercontent.com/leobsky/openwrt/refs/heads/6.6.100/6.12.40/target/linux/bcm27xx/patches-6.12/950-0155-staging-vchiq_arm-Register-bcm2835-codec-as-a-platfo.patch > target/linux/bcm27xx/patches-6.12/950-0155-staging-vchiq_arm-Register-bcm2835-codec-as-a-platfo.patch
curl -s https://raw.githubusercontent.com/leobsky/openwrt/refs/heads/6.6.100/6.12.40/target/linux/bcm27xx/patches-6.12/950-0161-staging-vchiq_arm-Set-up-dma-ranges-on-child-devices.patch > target/linux/bcm27xx/patches-6.12/950-0161-staging-vchiq_arm-Set-up-dma-ranges-on-child-devices.patch
curl -s https://raw.githubusercontent.com/leobsky/openwrt/refs/heads/6.6.100/6.12.40/target/linux/bcm27xx/patches-6.12/950-0163-staging-vchiq-Load-bcm2835_isp-driver-from-vchiq.patch > target/linux/bcm27xx/patches-6.12/950-0163-staging-vchiq-Load-bcm2835_isp-driver-from-vchiq.patch
curl -s https://raw.githubusercontent.com/leobsky/openwrt/refs/heads/6.6.100/6.12.40/target/linux/bcm27xx/patches-6.12/950-0325-mmc-bcm2835-Use-phys-addresses-for-slave-DMA-config.patch > target/linux/bcm27xx/patches-6.12/950-0325-mmc-bcm2835-Use-phys-addresses-for-slave-DMA-config.patch
curl -s https://raw.githubusercontent.com/leobsky/openwrt/refs/heads/6.6.100/6.12.40/target/linux/bcm27xx/patches-6.12/950-0758-mmc-bcm2835-Add-downstream-overclocking-support.patch > target/linux/bcm27xx/patches-6.12/950-0758-mmc-bcm2835-Add-downstream-overclocking-support.patch
curl -s https://raw.githubusercontent.com/leobsky/openwrt/refs/heads/6.6.100/6.12.40/target/linux/generic/hack-6.12/661-kernel-ct-size-the-hashtable-more-adequately.patch > target/linux/generic/hack-6.12/661-kernel-ct-size-the-hashtable-more-adequately.patch
curl -s https://raw.githubusercontent.com/leobsky/openwrt/refs/heads/6.6.100/6.12.40/target/linux/generic/pending-6.12/630-packet_socket_type.patch > target/linux/generic/pending-6.12/630-packet_socket_type.patch
curl -s https://raw.githubusercontent.com/leobsky/openwrt/refs/heads/6.6.100/6.12.40/target/linux/generic/pending-6.12/640-net-bridge-fix-switchdev-host-mdb-entry-updates.patch > target/linux/generic/pending-6.12/640-net-bridge-fix-switchdev-host-mdb-entry-updates.patch
curl -s https://raw.githubusercontent.com/leobsky/openwrt/refs/heads/6.6.100/6.12.40/target/linux/generic/pending-6.12/641-net-bridge-switchdev-Don-t-drop-packets-between-port.patch > target/linux/generic/pending-6.12/641-net-bridge-switchdev-Don-t-drop-packets-between-port.patch
curl -s https://raw.githubusercontent.com/leobsky/openwrt/refs/heads/6.6.100/6.12.40/target/linux/generic/pending-6.12/681-net-remove-NETIF_F_GSO_FRAGLIST-from-NETIF_F_GSO_SOF.patch > target/linux/generic/pending-6.12/681-net-remove-NETIF_F_GSO_FRAGLIST-from-NETIF_F_GSO_SOF.patch
curl -s https://raw.githubusercontent.com/leobsky/openwrt/refs/heads/6.6.100/6.12.40/target/linux/ramips/patches-6.12/825-i2c-MIPS-adds-ralink-I2C-driver.patch > target/linux/ramips/patches-6.12/825-i2c-MIPS-adds-ralink-I2C-driver.patch
curl -s https://raw.githubusercontent.com/leobsky/openwrt/refs/heads/6.6.100/6.12.40/target/linux/realtek/patches-6.12/310-add-i2c-rtl9300-support.patch > target/linux/realtek/patches-6.12/310-add-i2c-rtl9300-support.patch

rm -rf target/linux/generic/pending-6.12/680-net-fix-TCP-UDP-fraglist-GRO.patch
rm -rf target/linux/generic/pending-6.12/802-nvmem-u-boot-env-align-endianness-of-crc32-values.patch