SUMMARY = "Enforce static MAC addresses"
DESCRIPTION = "Set a priority on MAC addresses to run with: \
               factory-specified > u-boot-specified > random"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

RDEPENDS:${PN} += "bash"

PV = "1.0"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

SRC_URI = "\
    file://mac-check \
    file://${BPN}.service \
    file://mac_check.cpp;subdir=${BP} \
    file://CMakeLists.txt;subdir=${BP} \
    "

inherit cmake pkgconfig
inherit obmc-phosphor-systemd

DEPENDS += " \
            sdbusplus \
            phosphor-logging \
            boost \
           "

SYSTEMD_SERVICE:${PN} += "${PN}.service"

do_install:append() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/mac-check ${D}${bindir}
}
