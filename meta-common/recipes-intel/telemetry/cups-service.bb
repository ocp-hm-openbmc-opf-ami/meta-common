SUMMARY = "cups-service"
DESCRIPTION = "CUPS - Cpu Utilization Per Second service"

SRC_URI:bhs-features = "git://git@github.com/intel-bmc/firmware.bmc.openbmc.applications.cups-service.git;protocol=ssh;branch=main"
SRC_URI = "git://git@github.com/intel-bmc/firmware.bmc.openbmc.applications.cups-service.git;protocol=ssh;branch=egs"

SRCREV:bhs-features = "342d4dafcd2254d34f65fbc5eaa57b6931c7bd35"
SRCREV = "328f7d497f74a4667aef5b5068db4c5d57669303"
S = "${WORKDIR}/git"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Telemetry;md5=858e10cab31872ff374c48e5240d566a"

EXTRA_OECMAKE += "-DYOCTO_DEPENDENCIES=ON"

inherit cmake
inherit pkgconfig
inherit systemd

DEPENDS = "boost libpeci systemd sdbusplus cli11"

SYSTEMD_SERVICE:${PN} += "xyz.openbmc_project.CupsService.service"

EXTRA_OECMAKE += "-DENABLE_UT=OFF -DUT_ONLY=OFF -DENABLE_UT_EXECUTION=OFF"
