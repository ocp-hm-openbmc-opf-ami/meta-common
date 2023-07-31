SUMMARY = "Callback Manager"
DESCRIPTION = "D-Bus daemon that registers matches that trigger method calls"

SRC_URI = "git://github.com/openbmc/s2600wf-misc.git;branch=master;protocol=https"

inherit cmake systemd
DEPENDS = "boost sdbusplus"

PV = "0.1+git${SRCPV}"
SRCREV = "ad11f7df3ead2b42d1688fe2cd5b2531f2912c73"

S = "${WORKDIR}/git/callback-manager"

SYSTEMD_SERVICE:${PN} += "callback-manager.service"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENCE;md5=7becf906c8f8d03c237bad13bc3dac53"

EXTRA_OECMAKE = "-DYOCTO=1"
