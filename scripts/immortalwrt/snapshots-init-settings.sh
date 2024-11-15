#!/bin/bash
#=================================================
# File name: init-settings.sh
# System Required: Linux
# Version: 1.0
# Lisence: MIT
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================
# Set default theme to luci-theme-argon
uci set luci.main.mediaurlbase='/luci-static/argon'
uci set luci.main.pollinterval='1'
uci commit luci

# timezone
uci set system.@system[0].timezone=CST-8
uci set system.@system[0].zonename=Asia/Shanghai
uci commit system

# log level
uci set system.@system[0].conloglevel='1'
uci set system.@system[0].cronloglevel='9'
uci commit system

# diagnostics
uci set luci.diag.dns='www.baidu.com'
uci set luci.diag.ping='www.baidu.com'
uci set luci.diag.route='www.baidu.com'
uci commit luci

# packet steering
uci -q get network.globals.packet_steering > /dev/null || {
    uci set network.globals='globals'
    uci set network.globals.packet_steering=1
    uci commit network
}

# disable coremark
sed -i '/coremark/d' /etc/crontabs/root
crontab /etc/crontabs/root

# Disable opkg signature check
# sed -i 's/option check_signature/# option check_signature/g' /etc/opkg.conf
# 禁用ipv6前缀
sed -i 's/^[^#].*option ula/#&/' /etc/config/network
# Disable autostart by default for some packages
cd /etc/rc.d
rm -f S98udptools || true
rm -f S99nft-qos || true

# Try to execute init.sh (if exists)

if [ ! -f "/boot/init.sh" ]; then
bash /boot/init.sh
fi

exit 0
