#!/bin/bash
# Set to local prepare

curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/include/kernel-6.6 > include/kernel-6.6
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/bcm27xx/patches-6.6/950-0106-Add-support-for-all-the-downstream-rpi-sound-card-dr.patch > target/linux/bcm27xx/patches-6.6/950-0106-Add-support-for-all-the-downstream-rpi-sound-card-dr.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/generic/pending-6.6/100-compiler.h-only-include-asm-rwonce.h-for-kernel-code.patch > target/linux/generic/pending-6.6/100-compiler.h-only-include-asm-rwonce.h-for-kernel-code.patch
curl -s https://raw.githubusercontent.com/openwrt/openwrt/refs/heads/main/target/linux/generic/pending-6.6/701-netfilter-nf_tables-ignore-EOPNOTSUPP-on-flowtable-d.patch > target/linux/generic/pending-6.6/701-netfilter-nf_tables-ignore-EOPNOTSUPP-on-flowtable-d.patch