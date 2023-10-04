FILESEXTRAPATHS:append:intel-ast2600:= "${THISDIR}/files:"

#TODO CTL: replace patch with board id checking for CTL
SRC_URI:append:intel-ast2600 = " \
    file://securebootctl.cfg \
    file://0001-Add-board-ID-checking-and-dtb-selection-support.patch \
    file://0002-FFUJ-Port-Firmware-Update-Commands.patch \
    file://0003-AST2600-redefining-u-boot-env-changes-as-per-secure-boot-layout.patch \
    "

SRC_URI:append:intel-ast2600 = "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', 'file://0004-Debug-Enable-firmware-update-support-when-FFUJ-is-set.patch', 'file://0004-Release-Enable-firmware-update-support-when-FFUJ-is-set.patch', d)}"

SRC_URI:append:intel-ast2600 = " \
    file://0005-Add-ROT-Image-type-support-in-u-boot.patch \
    file://0006-Add-get-and-set-boot-address-api.patch \
    file://0007-Updated-u-boot-config-for-CTL.patch \
    file://0008-Secondary-Partition-SPI-flash.patch \
    file://0009-Read-PFM-root_key-from-SPI-flash.patch \
    file://0006-FMC-WDT2-Timer-set-to-BMC-boot-time.patch \
    file://0010-Verify-PFM-content-from-SPI-flash.patch \
    file://0011-secureboot-dynamic-changes-of-FIT-image-address-based-on-BBSRAM-register.patch \
    file://0012-Secure-boot-flash-partition-update.patch \
    file://0013-Verify-SVN-for-FW-update.patch \
    file://0015-secureboot-dynamic-changes-of-Uboot-FIT-image-address-based-on-BBSRAM-register.patch \
    file://0016-CTL-Fix-for-otp-image-flashing.patch \
    file://0017-secureboot-updating-boot-status-and-imagerecovery.patch \
    file://0018-SVN-check-functionality-for-u-boot.patch \    
    file://0019-Add-environment-variable-for-key-index.patch \
    file://0020-Active-image-register-read-and-write-fixes.patch \
    file://0021-CTL-Add-support-to-get-Device-ID-in-Uboot.patch \
    file://0022-CTL-Uboot-Image-Recovery-Fix.patch \
    file://0024-Kernel-recovery-when-WDT-kill.patch \
    file://0025-CTL-Fix-for-missing-otp_svn-after-full-flash.patch \
    file://0026-CTL-RoT-Source-fix-in-secureboot.patch \
    file://0027-CTL-Kernel-not-switching-after-firmware-update.patch \
    file://0028-Added-fix-for-lock-release-and-integer-overflow.patch \
    file://0030-Skip-Firmware-Update-Mode-Commands-when-SPI-flash.patch \
    file://0033-CTL-Enabling-PCIe-L1-on-catlow.patch \
    file://0034-CTL-Fix-for-wrong-image-boot-after-firmware-update.patch \
    file://0035-CTL-Adding-SVN-check-using-otp-rid-command-in-U-boot.patch \
    file://0036-CTL-Fix-for-otp-svn-read-failure.patch \
    "
