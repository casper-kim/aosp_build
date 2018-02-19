# Always needed
PRODUCT_COPY_FILES += $(call gapps-copy-to-system,all,framework)

GAPPS_NEXUS_CODENAMES += \
    crespo \
    crespo4g \
    maguro \
    toro \
    toroplus \
    grouper \
    tilapia \
    manta \
    mako \
    flo \
    deb \
    hammerhead \
    flounder \
    shamu \
    angler

GAPPS_PIXEL_CODENAMES += \
    marlin \
    muskie \
    taimen \
    wahoo

gapps_etc_files := $(call gapps-copy-to-system,all,etc)

# Remove google_build.xml on non-Pixel devices
ifeq ($(filter $(GAPPS_PIXEL_CODENAMES),$(TARGET_PRODUCT)),)
  gapps_etc_files := $(filter-out %sysconfig/google_build.xml,$(gapps_etc_files))
endif

# Remove nexus.xml on non-Nexus devices
ifeq ($(filter $(GAPPS_NEXUS_CODENAMES),$(TARGET_PRODUCT)),)
  gapps_etc_files := $(filter-out %sysconfig/nexus.xml,$(gapps_etc_files))
endif

# This is included as part of GoogleDialer build, for devices that have the
# GoogleDialer
gapps_etc_files := $(filter-out %sysconfig/dialer_experience.xml,$(gapps_etc_files))

PRODUCT_COPY_FILES += $(gapps_etc_files)

# check if we are building a vendor image
ifneq ($(CALLED_FROM_SETUP),true)
BUILD_VENDORIMAGE := $(shell CALLED_FROM_SETUP=true BUILD_SYSTEM=build/core \
      command make --no-print-directory -f build/core/config.mk dumpvar-BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE)
endif

# Pico and higher
ifneq ($(filter pico,$(TARGET_GAPPS_VARIANT)),)
# vendor/pittpatt seems to be removed on N+ (so only copy it to older than N)
ifeq ($(filter 24,$(call get-allowed-api-levels)),)
  PITTPATT_COPY_FILES := $(call gapps-copy-to-system,all,vendor/pittpatt)
# if we are building a vendor image, then we cannot copy to system/vendor, so update our copy statements.
ifdef BUILD_VENDORIMAGE
  PITTPATT_COPY_FILES := $(subst :system/vendor/pittpatt,:vendor/pittpatt,$(PITTPATT_COPY_FILES))
endif
  PRODUCT_COPY_FILES += $(PITTPATT_COPY_FILES)
endif
  PRODUCT_COPY_FILES += $(call gapps-copy-to-system,all,usr/srec)
endif

# Reset internal variables
gapps_etc_files :=
