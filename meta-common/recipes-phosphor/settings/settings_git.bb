SUMMARY = "Settings"

SRC_URI = "git://git@github.com/intel-bmc/firmware.bmc.openbmc.applications.settings-manager.git;protocol=ssh;branch=main"
SRCREV = "72a1e75317fafe8b8f4771554a40a1ca30365f78"
PV = "0.1+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"


SYSTEMD_SERVICE:${PN} = "xyz.openbmc_project.Settings.service"

DEPENDS = "boost \
           nlohmann-json \
           sdbusplus"

S = "${WORKDIR}/git"
inherit cmake systemd

EXTRA_OECMAKE = "-DYOCTO=1"

