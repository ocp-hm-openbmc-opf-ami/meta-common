SUMMARY = "cups-ut"
DESCRIPTION = "CUPS unit tests"

SRC_URI:bhs-features = "git://git@github.com/intel-collab/firmware.bmc.openbmc.applications.cups-service.git;protocol=ssh;branch=main"
SRC_URI = "git://git@github.com/intel-collab/firmware.bmc.openbmc.applications.cups-service.git;protocol=ssh;branch=egs"

SRCREV:bhs-features = "342d4dafcd2254d34f65fbc5eaa57b6931c7bd35"
SRCREV = "328f7d497f74a4667aef5b5068db4c5d57669303"
S = "${WORKDIR}/git"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Telemetry;md5=858e10cab31872ff374c48e5240d566a"

EXTRA_OECMAKE += "-DYOCTO_DEPENDENCIES=ON"

inherit cmake
inherit native

DEPENDS = "boost-native gtest-native"

EXTRA_OECMAKE += "-DENABLE_UT=ON -DUT_ONLY=ON -DENABLE_UT_EXECUTION=ON"
