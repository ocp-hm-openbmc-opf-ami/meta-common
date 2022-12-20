SUMMARY = "SPDM Responder Stack"
DESCRIPTION = "Implementation of SPDM specifications"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-FWSEC;md5=8ad5886152d8fa09daa41fbe51fff047"

inherit systemd
inherit pkgconfig meson

DEPENDS += " \
            systemd boost spdmapplib\
            "

SRC_URI = "git://git@github.com/intel-collab/firmware.bmc.openbmc.applications.spdmd.git;protocol=ssh;branch=main"
SRCREV = "adc31e1402c579ae0c4ff7a018938dd398740424"

S = "${WORKDIR}/git"
PV = "1.0+git${SRCPV}"

SYSTEMD_SERVICE:${PN} = "xyz.openbmc_project.spdmd.service"

