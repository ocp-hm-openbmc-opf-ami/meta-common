SUMMARY = "Partition Boot Daemon"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

PR = "r1"

inherit systemd
inherit pkgconfig cmake

DEPENDS += "autoconf-archive-native \
            systemd phosphor-logging phosphor-dbus-interfaces boost\
            "
DEPENDS +=" libgpiod"
RDEPENDS:${PN} +=" libgpiod"

SYSTEMD_SERVICE:${PN} = "${PN}.service"

S="${WORKDIR}/src"

SRC_URI = " \
    file://src \
    "
SRCREV = "${AUTOREV}"


