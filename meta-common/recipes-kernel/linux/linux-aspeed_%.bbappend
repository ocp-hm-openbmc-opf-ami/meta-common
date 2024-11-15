FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LINUX_VERSION = "6.6.47"

KERNEL_VERSION_SANITY_SKIP="1"

KBRANCH = "dev-6.6"
KSRC = "git://git.ami.com/core/ami-bmc/base-tech/linux-lf.git;protocol=https;branch=${KBRANCH}"
# https://git.ami.com/core/ami-bmc/base-tech/linux-lf.git

# Include this as a comment only for downstream auto-bump
# SRC_URI = "git://git@github.com/intel-bmc/os.linux.kernel.openbmc.linux.git;protocol=ssh;branch=dev-6.1-intel"
SRCREV="1760371b277718062211fc7eb6f3042c5051c1a5"

do_compile:prepend(){
   # device tree compiler flags
   export DTC_FLAGS=-@
}

SRC_URI += "file://defconfig \
	file://0001-Intel-CRB-related-dts-dtsi-files.patch \
"

SRC_URI += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', 'file://debug.cfg', '', d)}"
