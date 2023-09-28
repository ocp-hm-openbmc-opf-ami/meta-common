SUMMARY = "DIMM Devices Accessor"
DESCRIPTION = "DIMM Devices Accessor"

SRC_URI = "git://git@github.com/intel-collab/firmware.bmc.openbmc.applications.dimm-devices-accessor.git;protocol=ssh;branch=main"
SRCREV = "12dcac94fafd498ca8a98751230fa800d528346c"
S = "${WORKDIR}/git"
PV = "1.0+git${SRCPV}"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

DEPENDS += " \
    libpeci \
"

inherit meson pkgconfig systemd
