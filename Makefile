include $(TOPDIR)/rules.mk

PKG_NAME:=autoban
PKG_VERSION:=0.0.1
PKG_RELEASE:=1
PKG_MAINTAINER:=Yang Fan <fonlan@gmail.com>

define Package/autoban
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Auto ban IP if multi bad password SSH login for dropbear.
  URL:=https://github.com/fonlan/autoban
  DEPENDS:=+iptables +tr
endef