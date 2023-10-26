SUMMARY = "Callback Manager"
DESCRIPTION = "D-Bus daemon that registers matches that trigger method calls"

SRC_URI = "git://github.com/openbmc/s2600wf-misc.git;branch=master;protocol=https"

inherit cmake pkgconfig systemd
DEPENDS = "boost sdbusplus"

PV = "0.1+git${SRCPV}"
SRCREV = "a2c6e1d04dd82834ae002237bfef3cc52ab47138"

S = "${WORKDIR}/git/callback-manager"

SYSTEMD_SERVICE:${PN} += "callback-manager.service"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENCE;md5=7becf906c8f8d03c237bad13bc3dac53"

EXTRA_OECMAKE = "-DYOCTO=1"
