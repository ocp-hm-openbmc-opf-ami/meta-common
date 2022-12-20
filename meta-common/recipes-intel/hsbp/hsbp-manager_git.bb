SUMMARY = "HSBP Manager"
DESCRIPTION = "HSBP Manager monitors HSBPs through SMBUS"

SRC_URI = "git://github.com/openbmc/s2600wf-misc.git;branch=master;protocol=https"
SRCREV = "f61f1fe0299eebf8749b6a43a858716f8e8e3ab2"
PV = "0.1+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SYSTEMD_SERVICE:${PN} = "hsbp-manager.service"

DEPENDS = "boost \
           i2c-tools \
           sdbusplus \
           libgpiod"

S = "${WORKDIR}/git/hsbp-manager"
inherit cmake systemd

EXTRA_OECMAKE = "-DYOCTO=1"

