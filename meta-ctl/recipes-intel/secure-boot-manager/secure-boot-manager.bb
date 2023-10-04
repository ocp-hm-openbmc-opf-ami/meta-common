SUMMARY = "Secure Boot Manager"
DESCRIPTION = "Secure Boot Utilities"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

inherit systemd meson pkgconfig

SRC_URI = "git://git@github.com/intel-innersource/firmware.bmc.openbmc.applications.secure-boot-manager.git;protocol=ssh;branch=main"

PV = "0.1+git${SRCPV}"
SRCREV = "947ca24a91a3f1d3ce706952b79c37dc2cf4036d"

S = "${WORKDIR}/git"

RDEPENDS:${PN} = "bash"

DEPENDS += " \
    boost \
    sdbusplus \
    systemd \
    openssl \
    "

EXTRA_OEMESON = "-Dyocto_dep='enabled'"

FILES:${PN} += "${systemd_system_unitdir}/xyz.openbmc_project.secureFWmanager.service"
SYSTEMD_SERVICE:${PN} += "xyz.openbmc_project.secureFWmanager.service"
FILES:${PN} += "${systemd_system_unitdir}/secureFWInit.service"
SYSTEMD_SERVICE:${PN} += "secureFWInit.service"
