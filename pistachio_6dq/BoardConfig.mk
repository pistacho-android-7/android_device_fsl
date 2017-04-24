#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
include device/fsl/pistachio_6dq/build_id.mk
include device/fsl/imx6/BoardConfigCommon.mk
# pistachio_6dq default target for EXT4
BUILD_TARGET_FS ?= ext4
include device/fsl/imx6/imx6_target_fs.mk

ADDITIONAL_BUILD_PROPERTIES += \
                        ro.internel.storage_size=/sys/block/mmcblk2/size \
                        ro.boot.storage_type=sd \
                        ro.frp.pst=/dev/block/mmcblk2p12
TARGET_RECOVERY_FSTAB = device/fsl/pistachio_6dq/fstab.freescale
PRODUCT_COPY_FILES +=	\
	device/fsl/pistachio_6dq/fstab.freescale:root/fstab.freescale


TARGET_BOOTLOADER_BOARD_NAME := PISTACHIO
PRODUCT_MODEL := PISTACHIO-MX6DQ

TARGET_BOOTLOADER_POSTFIX := imx

TARGET_RELEASETOOLS_EXTENSIONS := device/fsl/imx6
# UNITE is a virtual device.

# Connectivity - Wi-Fi
USES_TI_MAC80211 := true
ifeq ($(USES_TI_MAC80211),true)
BOARD_WLAN_DEVICE            := wl12xx_mac80211
BOARD_SOFTAP_DEVICE              := wl12xx_mac80211
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
WPA_SUPPLICANT_VERSION      := VER_0_8_X
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB  := lib_driver_cmd_wl12xx
BOARD_HOSTAPD_PRIVATE_LIB         := lib_driver_cmd_wl12xx

WIFI_DRIVER_MODULE_NAME          := "wl18xx"
WIFI_DRIVER_MODULE_PATH          := "/system/lib/modules/wl18xx.ko"
COMMON_GLOBAL_CFLAGS += -DUSES_TI_MAC80211
COMMON_GLOBAL_CFLAGS += -DANDROID_P2P_STUB

# SoftAP workaround
WIFI_BYPASS_FWRELOAD      := true

PRODUCT_COPY_FILES += \
				kernel_imx/drivers/net/wireless/ti/wl18xx/wl18xx.ko:system/lib/modules/wl18xx.ko
endif

BOARD_MODEM_VENDOR := AMAZON

USE_ATHR_GPS_HARDWARE := true
USE_QEMU_GPS_HARDWARE := false

#for accelerator sensor, need to define sensor type here
BOARD_HAS_SENSOR := true
SENSOR_MMA8451 := true

# for recovery service
TARGET_SELECT_KEY := 28

# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false
DM_VERITY_RUNTIME_CONFIG := true
# uncomment below lins if use NAND
#TARGET_USERIMAGES_USE_UBIFS = true


ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
UBI_ROOT_INI := device/fsl/pistachio_6dq/ubi/ubinize.ini
TARGET_MKUBIFS_ARGS := -m 4096 -e 516096 -c 4096 -x none
TARGET_UBIRAW_ARGS := -m 4096 -p 512KiB $(UBI_ROOT_INI)
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

BOARD_KERNEL_CMDLINE := console=ttymxc3,115200 init=/init video=mxcfb0:dev=ldb,bpp=32 video=mxcfb1:off video=mxcfb2:off video=mxcfb3:off vmalloc=128M androidboot.console=ttymxc0 consoleblank=0 androidboot.hardware=freescale cma=448M

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
#UBI boot command line.
# Note: this NAND partition table must align with MFGTool's config.
BOARD_KERNEL_CMDLINE +=  mtdparts=gpmi-nand:16m(bootloader),16m(bootimg),128m(recovery),-(root) gpmi_debug_init ubi.mtd=3
endif


# Broadcom BCM4339 BT
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_TI := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/fsl/pistachio_6dq/bluetooth

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

PHONE_MODULE_INCLUDE := true
# camera hal v3
IMX_CAMERA_HAL_V3 := true

#define consumer IR HAL support
IMX6_CONSUMER_IR_HAL := false

TARGET_BOOTLOADER_CONFIG := mx6_pistachio_android_defconfig
TARGET_KERNEL_DEFCONF := nutsboard_imx_android_defconfig
TARGET_BOARD_DTS_CONFIG := imx6q-pistachio.dtb

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx6/sepolicy \
       device/fsl/pistachio_6dq/sepolicy

BOARD_SECCOMP_POLICY += device/fsl/pistachio_6dq/seccomp

TARGET_BOARD_KERNEL_HEADERS := device/fsl/common/kernel-headers
