#
# (с) 2025 DOTYCAT (https://github.com/dotycat/luci-app-nfttl)
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-nfttl
PKG_VERSION:=1.0.0
PKG_RELEASE:=1
PKG_MAINTAINER:=DOTYCAT <https://github.com/dotycat/luci-app-nfttl>

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  TITLE:=TTL Control - Set or disable TTL packet rewriting
  URL:=https://github.com/dotycat/luci-app-nfttl
  PKGARCH:=all
  DEPENDS:=+nftables +luci-base
endef

define Package/$(PKG_NAME)/description
  A LuCI application to configure TTL (Time to Live) packet rewriting rules.
endef

define Package/$(PKG_NAME)/conffiles
  /etc/config/nfttl
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/nfttl
	$(INSTALL_DATA) ./files/model/cbi/nfttl.lua $(1)/usr/lib/lua/luci/model/cbi/nfttl.lua

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/nfttl.lua $(1)/usr/lib/lua/luci/controller/nfttl.lua

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/nfttl $(1)/etc/config/nfttl
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
