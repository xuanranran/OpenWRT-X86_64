#
# Copyright (C) 2006-2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=clang
PKG_VERSION:=19.0.1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-x86_64-unknown-linux-gnu.tar.xz
PKG_SOURCE_URL:=https://github.com/sbwml/openwrt-llvm-toolchain/releases/download/$(PKG_VERSION)/
PKG_HASH:=a73c5ec6d62e0f47fd3cf25e3904b5818b18695b7302a9b404e411f2085110a3

PKG_MAINTAINER:=sbwml <admin@cooluc.com>
PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/host-build.mk

define Host/Prepare
	$(TAR) --strip-components=1 -C $(HOST_BUILD_DIR) -xf $(DL_DIR)/$(PKG_NAME)-$(PKG_VERSION)-x86_64-unknown-linux-gnu.tar.xz
endef

define Host/Compile
endef

define Host/Install
	$(CP) -a $(HOST_BUILD_DIR)/{bin,include,lib} $(STAGING_DIR_HOST)/
	$(RM) -rf $(HOST_BUILD_DIR)/{bin,include,lib,libexec,share}
endef

define Host/Uninstall
	( \
		rm -rf $(STAGING_DIR_HOST)/bin/{*clang*,dsymutil,find-all-symbols,*lld*,llc,lli,llvm*,merge-fdata,opt,perf2bolt,wasm-ld} ; \
		rm -rf $(STAGING_DIR_HOST)/include/{aarch64-unknown-linux-musl,arm-unknown-linux-musleabihf,c++,clang*,i386-unknown-linux-gnu,i686-unknown-linux-musl,lld,llvm*,mach-o,polly,x86_64-unknown-linux-gnu,x86_64-unknown-linux-musl} ; \
		rm -rf $(STAGING_DIR_HOST)/lib/{aarch64-unknown-linux-musl,arm-unknown-linux-musleabihf,bfd-plugins,clang,cmake,i386-unknown-linux-gnu,i686-unknown-linux-musl,libbolt*,libfindAllSymbols.a,liblld*,*LLVM*,libPolly*,libRemarks.so,libxml2*,x86_64-unknown-linux-gnu,x86_64-unknown-linux-musl} ; \
	)
endef

$(eval $(call HostBuild))
