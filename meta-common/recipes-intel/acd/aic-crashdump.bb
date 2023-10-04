SUMMARY = "AIC-crash dump"
DESCRIPTION = "Implementation of add-in card crashdump collection over MCTP"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-ACD;md5=eed054adf11169b8a51e82ece595b6c6"

inherit systemd meson pkgconfig

SRC_URI = "git://git@github.com/intel-bmc/firmware.bmc.openbmc.applications.crashdump-add-in-card.git;protocol=ssh;branch=main"
SRCREV = "2b672eed528b673bac5d829bc34ad9fd393689d7"

S = "${WORKDIR}/git"

PV = "1.0+git${SRCPV}"


FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS += " \
    systemd \
    sdbusplus \
    phosphor-logging \
    boost \
    phosphor-dbus-interfaces \
    mctpwplus \
    "
EXTRA_OEMESON = "-Dyocto_dep='enabled'"

FILES:${PN} += "${systemd_system_unitdir}/xyz.openbmc_project.aic_crashdump.service"
SYSTEMD_SERVICE:${PN} += "xyz.openbmc_project.aic_crashdump.service"
