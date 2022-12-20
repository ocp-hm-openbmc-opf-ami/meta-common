SUMMARY = "Security Manager daemon to detect the security violation- ASD/ user management"
DESCRIPTION = "Daemon check for Remote debug enable and user account violation"

PV = "1.0+git${SRCPV}"

S = "${WORKDIR}/git"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
inherit cmake systemd

SRC_URI = "git://git@github.com/intel-collab/firmware.bmc.openbmc.applications.security-manager.git;protocol=ssh;branch=main"
SRCREV = "4478fee98c5e198cc3759c49e5c343ee0bafbcef"

SYSTEMD_SERVICE:${PN} += "xyz.openbmc_project.SecurityManager.service"

DEPENDS += " \
    systemd \
    sdbusplus \
    libgpiod \
    phosphor-logging \
    boost \
    "
