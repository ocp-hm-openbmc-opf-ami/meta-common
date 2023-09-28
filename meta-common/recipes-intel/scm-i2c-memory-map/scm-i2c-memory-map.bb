SUMMARY = "scm-i2c-memory-map service"
DESCRIPTION = "Exposes memory map of CPLDs (Complex Programmable Logic Device) that are part of DC-SCM board (Datacenter Secure Control Module) over I2C."

# Modify these as desired
PV = "1.0+git${SRCPV}"

SRC_URI = "git://git@github.com/intel-bmc/firmware.bmc.openbmc.applications.secure-control-module-i2c-memory-map.git;protocol=ssh;branch=main;"
SRCREV = "dbbe574d41ddf772e55dc68e8011c6d6e9bd4ec7"
S = "${WORKDIR}/git"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

inherit meson pkgconfig systemd externalsrc

DEPENDS = "systemd \
    boost \
    sdbusplus \
    i2c-tools \
    "

SYSTEMD_SERVICE:${PN} = "xyz.openbmc_project.scm_i2c_memory_map.service"

EXTRA_OEMESON = "--buildtype=minsize \
    -Dtests=disabled \
    -Dyocto-deps=enabled \
    -Dinstall-service=enabled \
    "
