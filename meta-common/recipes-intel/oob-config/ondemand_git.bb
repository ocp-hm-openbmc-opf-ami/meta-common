SUMMARY = "Intel On Demand feature"
DESCRIPTION = "Implementation of On Demand feature in BMC"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-OOB;md5=aadc6e5ae7830a3df62f34ad47fef210"

SRC_URI = "git://git@github.com/intel-bmc/firmware.bmc.openbmc.applications.ondemand.git;protocol=ssh;branch=main"
SRCREV = "0323e33e366ede30ec9fa634981006a897e4d982"

S = "${WORKDIR}/git"

PV = "1.0+git${SRCPV}"

inherit meson systemd pkgconfig

EXTRA_OEMESON = "-Dyocto_dep='enabled'"

DEPENDS += " \
    sdbusplus \
    systemd \
    phosphor-logging \
    boost \
    libpeci \
    nlohmann-json \
    spdmapplib \
    "

SYSTEMD_SERVICE:${PN} += "xyz.openbmc_project.ondemand.service"

