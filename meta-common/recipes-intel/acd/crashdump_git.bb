inherit obmc-phosphor-dbus-service
inherit obmc-phosphor-systemd

SUMMARY = "CPU Crashdump"
DESCRIPTION = "CPU utilities for dumping CPU Crashdump and registers over PECI"

DEPENDS = "boost cjson sdbusplus safec gtest libpeci bafi"
inherit cmake systemd pkgconfig

EXTRA_OECMAKE = "-DYOCTO_DEPENDENCIES=ON -DCRASHDUMP_BUILD_UT=OFF"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-ACD;md5=eed054adf11169b8a51e82ece595b6c6"

SRC_URI = "git://git@github.com/intel-bmc/firmware.bmc.openbmc.applications.crashdump.git;branch=main;protocol=ssh;nobranch=1"

SRCREV = "1783cac4e6638368b30e278e209149240ca7f8bc"

S = "${WORKDIR}/git"

SYSTEMD_SERVICE:${PN} += "com.intel.crashdump.service"

# linux-libc-headers guides this way to include custom uapi headers
CFLAGS:append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
CFLAGS:append = " -I ${STAGING_KERNEL_DIR}/include"
CXXFLAGS:append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
CXXFLAGS:append = " -I ${STAGING_KERNEL_DIR}/include"

# Copying the depricated header from kernel as a temporary fix to resolve build breaks.
# It should be removed later after fixing the header dependency in this repository.
SRC_URI += "file://asm/rwonce.h"
do_configure:prepend() {
    cp -r ${WORKDIR}/asm ${S}/asm
}
CFLAGS:append = " -I ${S}"
do_configure[depends] += "virtual/kernel:do_shared_workdir"

