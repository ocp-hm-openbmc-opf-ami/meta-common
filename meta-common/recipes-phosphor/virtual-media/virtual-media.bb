SUMMARY = "Virtual Media Service"
DESCRIPTION = "Virtual Media Service"

SRC_URI = "git://git@github.com/intel-collab/firmware.bmc.openbmc.applications.virtual-media.git;protocol=ssh;branch=main"
SRCREV = "cb07a04fe1748e038ce54c54fdc09bfa66dcea4d"

S = "${WORKDIR}/git"
PV = "1.0+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SYSTEMD_SERVICE:${PN} += "xyz.openbmc_project.VirtualMedia.service"

DEPENDS = "udev boost nlohmann-json systemd sdbusplus"

RDEPENDS:${PN} = "nbd-client nbdkit"

inherit cmake systemd

EXTRA_OECMAKE += "-DYOCTO_DEPENDENCIES=ON"
EXTRA_OECMAKE += "-DLEGACY_MODE_ENABLED=ON"

FULL_OPTIMIZATION = "-Os -pipe -flto -fno-rtti"
