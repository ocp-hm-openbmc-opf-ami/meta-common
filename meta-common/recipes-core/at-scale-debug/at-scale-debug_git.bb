inherit obmc-phosphor-systemd

SUMMARY = "At Scale Debug Service"
DESCRIPTION = "At Scale Debug Service exposes remote JTAG target debug capabilities"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=8929d33c051277ca2294fe0f5b062f38"


inherit cmake pkgconfig
DEPENDS = "sdbusplus openssl libpam libgpiod safec"

do_configure[depends] += "virtual/kernel:do_shared_workdir"

SRC_URI = "git://git@github.com/intel-bmc/firmware.bmc.openbmc.applications.at-scale-debug.git;protocol=ssh;branch=main"
SRCREV = "c0ad12b458c212b4a83076de7515a69787dbedff"

inherit useradd

USERADD_PACKAGES = "${PN}"

# add a special user asdbg
USERADD_PARAM:${PN} = "-u 999 asdbg"

S = "${WORKDIR}/git"

SYSTEMD_SERVICE:${PN} += "com.intel.AtScaleDebug.service"

# Specify any options you want to pass to cmake using EXTRA_OECMAKE:
EXTRA_OECMAKE = "-DBUILD_UT=OFF"

CFLAGS:append = " -I ${S}"
