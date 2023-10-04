SUMMARY = "BMC Collector"
DESCRIPTION = "BMC Collector daemon for remote endpoints"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-ACD;md5=eed054adf11169b8a51e82ece595b6c6"

SRC_URI = "git://git@github.com/intel-bmc/firmware.bmc.openbmc.applications.bmc-collector.git;protocol=ssh;branch=main"

# Modify these as desired
PV = "1.0+git${SRCPV}"
SRCREV = "456004da37335a85d0e0321e0c8916f99b991a04"

S = "${WORKDIR}/git"

SYSTEMD_SERVICE:${PN} += "xyz.openbmc_project.BmcCollector.service"

DEPENDS = " \
    boost \
    systemd \
    sdbusplus \
    nlohmann-json \
    openssl \
    "

inherit cmake pkgconfig systemd

EXTRA_OECMAKE += "-DYOCTO_DEPENDENCIES=ON"

FULL_OPTIMIZATION = "-Os -pipe -flto -fno-rtti"
