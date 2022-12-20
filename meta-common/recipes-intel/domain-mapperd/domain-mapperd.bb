SUMMARY = "CPU Domain ID Mapper Daemon"
DESCRIPTION = "Implementation of CPU Domain ID mapper daemon"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

inherit systemd meson pkgconfig

SRC_URI = "git://git@github.com/intel-collab/firmware.bmc.openbmc.applications.domain-mapperd.git;protocol=ssh;branch=main"
SRCREV = "fe77fe68f65bd5f62a91236e0930a80358f7827f"

S = "${WORKDIR}/git"
PV = "1.0+git${SRCPV}"

DEPENDS += " \
    systemd \
    sdbusplus \
    phosphor-logging \
    boost \
    phosphor-dbus-interfaces \
    mctpwplus \
    libpmt \
    "

EXTRA_OEMESON = "-Dyocto_dep='enabled'"

FILES:${PN} += "${systemd_system_unitdir}/com.intel.DomainMapper.service"
SYSTEMD_SERVICE:${PN} += "com.intel.DomainMapper.service"
