#
# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=qdpc-host
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define KernelPackage/qdpc-host
  SECTION:=kernel
  CATEGORY:=Kernel modules
  SUBMENU:=Quantenna WiFi driver
  TITLE:=Kernel driver for Quantenna chipsets
  FILES:=$(PKG_BUILD_DIR)/qdpc-host.ko
  KCONFIG:=
  AUTOLOAD:=$(call AutoLoad,40, qdpc-host)
	DEPENDS:=+kmod-qca-nss-drv +kmod-qca-nss-gmac
endef

define KernelPackage/qdpc-host/Default/description
 This package contains the proprietary wireless driver for the Quantenna
 chipset.
endef

define KernelPackage/qdpc-host/install
	$(INSTALL_DIR) $(1)/lib/firmware
	$(CP) ./binary/topaz-linux.lzma.img $(1)/lib/firmware/topaz-linux.lzma.img
	$(CP) ./binary/u-boot.bin $(1)/lib/firmware
endef

EXTRA_CFLAGS:= \
	$(patsubst CONFIG_%, -DCONFIG_%=1, $(patsubst %=m,%,$(filter %=m,$(EXTRA_KCONFIG)))) \
	$(patsubst CONFIG_%, -DCONFIG_%=1, $(patsubst %=y,%,$(filter %=y,$(EXTRA_KCONFIG)))) \
	-DDNI_EXTRA_FUNCTIONS -DSKIP_PCI_DMA_MASK -DDISABLE_PCIE_UPDATA_HW_BAR -DRX_IP_HDR_REALIGN -DQTN_TX_SKBQ_SUPPORT -DQTN_WAKEQ_SUPPORT -DQCA_NSS_PLATFORM \
	-I$(PKG_BUILD_DIR)/common -I$(PKG_BUILD_DIR)/include -I$(PKG_BUILD_DIR)

#-DDNI_5G_LED not included, due to lack of/no support

EXTRA_KCONFIG:= \
	CONFIG_QDPC_HOST=m

MAKE_OPTS:= \
	ARCH="$(LINUX_KARCH)" \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	SUBDIRS="$(PKG_BUILD_DIR)" \
	EXTRA_CFLAGS="$(EXTRA_CFLAGS)" \
	$(EXTRA_KCONFIG)

#MAKE_KMOD := $(MAKE) V=99 -C "$(LINUX_DIR)" \
#		CROSS_COMPILE="$(TARGET_CROSS)" \
#		ARCH="$(LINUX_KARCH)" \
#		PATH="$(TARGET_PATH)" \
#		DNI_KMOD_CFLAGS="-DDNI_5G_LED -DDNI_EXTRA_FUNCTIONS -DSKIP_PCI_DMA_MASK -DQCA_NSS_PLATFORM -I$(STAGING_DIR)/usr/include/qca-nss-drv -DDISABLE_PCIE_UPDATA_HW_BAR -DRX_IP_HDR_REALIGN"

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
		$(MAKE_OPTS) \
		modules
endef

$(eval $(call KernelPackage,qdpc-host))
