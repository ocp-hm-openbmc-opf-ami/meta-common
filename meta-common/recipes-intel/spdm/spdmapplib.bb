SUMMARY = "SPDM Application Library"
DESCRIPTION = "Library for SPDM applications"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-FWSEC;md5=8ad5886152d8fa09daa41fbe51fff047"


inherit pkgconfig meson

DEPENDS += " systemd \
            phosphor-logging \
            phosphor-dbus-interfaces \
            boost \
            mctpwplus \
            libspdm \
            "

SRC_URI += "git://git@github.com/intel-bmc/firmware.bmc.openbmc.libraries.spdmapplib.git;protocol=ssh;branch=main"

S = "${WORKDIR}/git"
SRCREV = "a438aced39283fc405560d539d165b05a42143b2"
PV = "1.0+git${SRCPV}"

EXTRA_OEMESON = "-Dyocto_dep='enabled'"

