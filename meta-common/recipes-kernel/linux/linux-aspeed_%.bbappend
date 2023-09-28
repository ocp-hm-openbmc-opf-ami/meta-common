FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LINUX_VERSION = "6.1.34"

KERNEL_VERSION_SANITY_SKIP="1"

KBUILD_DEFCONFIG = "intel_bmc_defconfig"
KBRANCH = "dev-6.1-intel"
KSRC = "git://git@github.com/intel-bmc/os.linux.kernel.openbmc.linux.git;protocol=ssh;branch=${KBRANCH}"
# Include this as a comment only for downstream auto-bump
# SRC_URI = "git://git@github.com/intel-bmc/os.linux.kernel.openbmc.linux.git;protocol=ssh;branch=dev-6.1-intel"
SRCREV="1bab8d06fe522e17defa4cf9ca887ac085d8cb93"

do_compile:prepend(){
   # device tree compiler flags
   export DTC_FLAGS=-@
}

SRC_URI += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', 'file://debug.cfg', '', d)}"
