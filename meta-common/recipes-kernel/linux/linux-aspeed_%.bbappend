FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LINUX_VERSION = "6.1.61"

KERNEL_VERSION_SANITY_SKIP="1"

KBUILD_DEFCONFIG = "intel_bmc_defconfig"
KBRANCH = "dev-6.1-intel"
KSRC = "git://git@github.com/intel-bmc/os.linux.kernel.openbmc.linux.git;protocol=ssh;branch=${KBRANCH}"
# Include this as a comment only for downstream auto-bump
# SRC_URI = "git://git@github.com/intel-bmc/os.linux.kernel.openbmc.linux.git;protocol=ssh;branch=dev-6.1-intel"
SRCREV="265d619a91b4d124688402ffde2dce07fd30fcbd"

do_compile:prepend(){
   # device tree compiler flags
   export DTC_FLAGS=-@
}

SRC_URI += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', 'file://debug.cfg', '', d)}"
