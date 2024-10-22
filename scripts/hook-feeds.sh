#!/bin/bash
# Set to local feeds
pushd customfeeds/lovepackages
export lovepackages_feed="$(pwd)"
popd
pushd customfeeds/loverely
export loverely_feed="$(pwd)"
popd

pushd customfeeds/packages
export packages_feed="$(pwd)"
popd
pushd customfeeds/luci
export luci_feed="$(pwd)"
popd

pushd customfeeds/routing
export routing_feed="$(pwd)"
popd
pushd customfeeds/telephony
export telephony_feed="$(pwd)"
popd
rm -rf customfeeds/packages/net/{*alist,chinadns-ng,dns2socks,dns2tcp,lucky,sing-box}
chmod 755 customfeeds/lovepackages/luci-app-onliner/root/usr/share/onliner/setnlbw.sh

# Update node 20.x
pushd customfeeds/packages/lang/node/
git clone --depth 1 https://github.com/immortalwrt/packages immortalwrt && mv -n immortalwrt/lang/node/* ./ ; rm -rf immortalwrt
popd

# Update node
rm -rf customfeeds/packages/lang/node
git clone https://github.com/sbwml/feeds_packages_lang_node-prebuilt customfeeds/packages/lang/node
# rm -rf customfeeds/packages/lang/node/*
# pushd customfeeds/packages/lang/node-yarn/
# git clone --depth 1 https://github.com/immortalwrt/packages immortalwrt && mv -n immortalwrt/lang/node-yarn/* ./ ; rm -rf immortalwrt
# popd

# ddns - fix boot
sed -i '/boot()/,+2d' customfeeds/packages/net/ddns-scripts/files/ddns.init

# nlbwmon - disable syslog
sed -i 's/stderr 1/stderr 0/g' customfeeds/packages/net/nlbwmon/files/nlbwmon.init

# samba4 - bump version
rm -rf customfeeds/packages/net/samba4
git clone https://github.com/sbwml/feeds_packages_net_samba4 customfeeds/packages/net/samba4
# liburing - 2.7 (samba-4.21.0)
rm -rf customfeeds/packages/libs/liburing
git clone https://github.com/sbwml/feeds_packages_libs_liburing customfeeds/packages/libs/liburing
# enable multi-channel
sed -i '/workgroup/a \\n\t## enable multi-channel' customfeeds/packages/net/samba4/files/smb.conf.template
sed -i '/enable multi-channel/a \\tserver multi channel support = yes' customfeeds/packages/net/samba4/files/smb.conf.template
# default config
sed -i 's/#aio read size = 0/aio read size = 0/g' customfeeds/packages/net/samba4/files/smb.conf.template
sed -i 's/#aio write size = 0/aio write size = 0/g' customfeeds/packages/net/samba4/files/smb.conf.template
sed -i 's/invalid users = root/#invalid users = root/g' customfeeds/packages/net/samba4/files/smb.conf.template
sed -i 's/bind interfaces only = yes/bind interfaces only = no/g' customfeeds/packages/net/samba4/files/smb.conf.template
sed -i 's/#create mask/create mask/g' customfeeds/packages/net/samba4/files/smb.conf.template
sed -i 's/#directory mask/directory mask/g' customfeeds/packages/net/samba4/files/smb.conf.template
sed -i 's/0666/0644/g;s/0744/0755/g;s/0777/0755/g' customfeeds/luci/applications/luci-app-samba4/htdocs/luci-static/resources/view/samba4.js
sed -i 's/0666/0644/g;s/0777/0755/g' customfeeds/packages/net/samba4/files/samba.config
sed -i 's/0666/0644/g;s/0777/0755/g' customfeeds/packages/net/samba4/files/smb.conf.template

# custom packages
rm -rf customfeeds/luci/applications/luci-app-filebrowser

# luci-compat - fix translation
sed -i 's/<%:Up%>/<%:Move up%>/g' customfeeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm
sed -i 's/<%:Down%>/<%:Move down%>/g' customfeeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm

# SQM Translation
mkdir -p customfeeds/packages/net/sqm-scripts/patches
curl -s https://raw.githubusercontent.com/xuanranran/r4s_build_script/refs/heads/master/openwrt/patch/sqm/001-help-translation.patch > feeds/packages/net/sqm-scripts/patches/001-help-translation.patch

# unzip
rm -rf customfeeds/packages/utils/unzip
git clone https://github.com/sbwml/feeds_packages_utils_unzip customfeeds/packages/utils/unzip

# tcp-brutal
git clone https://github.com/sbwml/package_kernel_tcp-brutal package/kernel/tcp-brutal

# watchcat - clean config
true > customfeeds/packages/utils/watchcat/files/watchcat.config

# Update nginx-util
rm -rf customfeeds/packages/net/nginx-util/*
pushd customfeeds/packages/net/nginx-util/
git clone --depth 1 https://github.com/immortalwrt/packages nginxutil && mv -n nginxutil/net/nginx-util/* ./ ; rm -rf nginxutil
popd

# Update golang 1.23.x
rm -rf customfeeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang customfeeds/packages/lang/golang
# git clone https://github.com/sbwml/packages_lang_golang -b 23.x customfeeds/packages/lang/golang

# Update dnsmasq
rm -rf package/network/services/dnsmasq/*
pushd package/network/services/dnsmasq/
git clone --depth 1 https://github.com/immortalwrt/immortalwrt immortalwrt && mv -n immortalwrt/package/network/services/dnsmasq/* ./ ; rm -rf immortalwrt
popd

rm -rf package/kernel/linux/modules/netsupport.mk
cp -r $GITHUB_WORKSPACE/data/package/kernel/linux/modules/netsupport.mk package/kernel/linux/modules/netsupport.mk

sed -i '/src-git lovepackages/d' feeds.conf.default
echo "src-link lovepackages $lovepackages_feed" >> feeds.conf.default
sed -i '/src-git loverely/d' feeds.conf.default
echo "src-link loverely $loverely_feed" >> feeds.conf.default

sed -i '/src-git packages/d' feeds.conf.default
echo "src-link packages $packages_feed" >> feeds.conf.default
sed -i '/src-git luci/d' feeds.conf.default
echo "src-link luci $luci_feed" >> feeds.conf.default

sed -i '/src-git routing/d' feeds.conf.default
echo "src-link routing $routing_feed" >> feeds.conf.default
sed -i '/src-git telephony/d' feeds.conf.default
echo "src-link telephony $telephony_feed" >> feeds.conf.default

# Update feeds
./scripts/feeds clean -a
./scripts/feeds update -a
