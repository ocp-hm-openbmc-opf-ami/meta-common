SUMMARY = "Modular System"
DESCRIPTION = "Modular System which can combine two or four 2-Socket systems to one 4S or 8S system"

SRC_URI = "git://git@github.com/intel-bmc/firmware.bmc.openbmc.applications.modular-system.git;protocol=ssh;branch=main"
SRCREV = "370fcb3a74c3bd44d55d24b414fe86cbb948ce97"

S = "${WORKDIR}/git"

PV = "1.0+git${SRCPV}"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

SYSTEMD_SERVICE:${PN} = "modularsystem.service"

inherit cmake
inherit systemd

DEPENDS += " \
    systemd \
    sdbusplus \
    phosphor-dbus-interfaces \
    phosphor-logging \
    boost \
    libgpiod \
    "
