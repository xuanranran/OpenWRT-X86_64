#!/bin/bash
#=================================================
# File name: preset-nikki-core.sh
# System Required: Linux
# Version: 1.0
# Lisence: MIT
# Author: LovinYarn
# github: https://github.com/xuanranran
#=================================================
mkdir -p files/etc/nikki/run/ui

GEOIP_URL="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat"
GEOSITE_URL="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat"
GEOIP_METADB_URL="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip-lite.metadb"
ASN_MMDB_URL="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/GeoLite2-ASN.mmdb"

wget -qO- $GEOIP_URL > files/etc/nikki/run/GeoIP.dat
wget -qO- $GEOSITE_URL > files/etc/nikki/run/GeoSite.dat
wget -qO- $GEOIP_METADB_URL > files/etc/nikki/run/geoip.metadb
wget -qO- $ASN_MMDB_URL > files/etc/nikki/run/ASN.mmdb
