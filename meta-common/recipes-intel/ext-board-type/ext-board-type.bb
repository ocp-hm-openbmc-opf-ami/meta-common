SUMMARY = "Extended Board Type"
DESCRIPTION = "Exposing extended Board Type"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

inherit systemd meson pkgconfig

SRC_URI = "\
    file://ext_board_type.cpp;subdir=${BP} \
    file://meson.build;subdir=${BP} \
    file://xyz.openbmc_project.ext_board_type.service;subdir=${BP} \
    "

DEPENDS += " \
systemd \
sdbusplus \
phosphor-logging \
boost \
phosphor-dbus-interfaces \
"

FILES:${PN} += "${systemd_system_unitdir}/xyz.openbmc_project.ext_board_type.service"
SYSTEMD_SERVICE:${PN} += "xyz.openbmc_project.ext_board_type.service"
