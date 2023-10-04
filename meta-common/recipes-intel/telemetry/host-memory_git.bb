SUMMARY = "Host memory application"

SRC_URI = "git://git@github.com/intel-bmc/firmware.bmc.openbmc.applications.host-memory.git;protocol=ssh;branch=main"
SRCREV = "1d9403141d86140b280970acb66d014b1f0457f7"
PV = "0.1+git${SRCPV}"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Telemetry;md5=858e10cab31872ff374c48e5240d566a"


DEPENDS = "boost \
           sdbusplus \
           libpeci \
           libgpiod"

S = "${WORKDIR}/git"
inherit cmake pkgconfig systemd

SYSTEMD_SERVICE:${PN} = "xyz.openbmc_project.CLTT.service"
