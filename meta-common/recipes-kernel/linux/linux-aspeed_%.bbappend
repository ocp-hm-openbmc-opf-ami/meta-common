FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LINUX_VERSION = "5.15.69"

KBUILD_DEFCONFIG = "intel_bmc_defconfig"
KBRANCH = "dev-5.15-intel"
KSRC = "git://git@github.com/intel-collab/os.linux.kernel.openbmc.linux.git;protocol=ssh;branch=${KBRANCH}"
# Include this as a comment only for downstream auto-bump
# SRC_URI = "git://git@github.com/intel-collab/os.linux.kernel.openbmc.linux.git;protocol=ssh;branch=dev-5.15-intel"
SRCREV="f25b323767a91298f76dd7fc660f2762735aa828"

do_compile:prepend(){
   # device tree compiler flags
   export DTC_FLAGS=-@
}

SRC_URI += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', 'file://debug.cfg', '', d)}"

SRC_URI += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'optee-ast2600', 'file://intel-optee.cfg', '', d)}"
