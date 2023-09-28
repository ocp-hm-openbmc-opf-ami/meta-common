FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

inherit obmc-phosphor-systemd
SYSTEMD_SERVICE:${PN} = "phosphor-pid-control.service"
EXTRA_OECONF = "--enable-configure-dbus=yes"

# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/phosphor-pid-control.git;branch=master;protocol=https"
SRCREV = "796f06dc6f0e8161ee9ecf085443c1ae0dc45216"

SRC_URI += "\
    file://0001-allow-dbus-sensors-without-thresholds.patch \
    "

FILES:${PN} = "${bindir}/swampd ${bindir}/setsensor"
