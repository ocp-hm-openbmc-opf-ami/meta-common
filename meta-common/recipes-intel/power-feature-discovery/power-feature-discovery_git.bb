SUMMARY = "TPMI Discovery and Control"
DESCRIPTION = "Exposes the host processor's Topology Aware Register and PM \
Capsule Interface (TPMI) details to other applications."

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"
SRC_URI = "git://git@github.com/intel-bmc/firmware.bmc.openbmc.applications.power-feature-discovery.git;protocol=ssh;branch=main"
SRCREV = "b46be048d9528ff78ccc8fadda52c36b4cd4552c"
PV = "1.0+git${SRCPV}"

DEPENDS += "phosphor-logging phosphor-dbus-interfaces boost sdbusplus libpeci"
S = "${WORKDIR}/git"

inherit meson systemd pkgconfig
EXTRA_OEMESON += "-Dtests=disabled"
SYSTEMD_SERVICE:${PN} = "com.intel.TPMI.service"
