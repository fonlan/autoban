include $(TOPDIR)/rules.mk

PKG_NAME:=autoban
PKG_VERSION:=0.0.1
PKG_RELEASE:=1
PKG_MAINTAINER:=Yang Fan <fonlan@gmail.com>

include $(INCLUDE_DIR)/package.mk

define Package/autoban
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Auto ban IP if multi bad password SSH login for dropbear.
  URL:=https://github.com/fonlan/autoban
  DEPENDS:=+iptables
endef

define Package/autoban/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(CP) ./files/autoban $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) ./files/autoban.sh $(1)/usr/bin
endef

$(eval $(call BuildPackage,autoban))