SUMMARY = "ME watchdog"
DESCRIPTION = "Enables ME recovery after heartbeat timeout"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

SRC_URI = "git://git@github.com/intel-collab/firmware.bmc.openbmc.applications.me-watchdog.git;protocol=ssh;nobranch=1"
SRCREV = "c3e99c473921424cf685bc13d9f7d99e6c8e3c19"

S = "${WORKDIR}/git"

PV = "1.0+git${SRCPV}"

SYSTEMD_SERVICE:${PN} = "xyz.openbmc_project.intel.sps.health.service"

DEPENDS = "boost sdbusplus libgpiod nlohmann-json"

inherit meson systemd
