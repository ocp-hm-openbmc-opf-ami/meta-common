FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

inherit obmc-phosphor-systemd
SYSTEMD_SERVICE:${PN} = "phosphor-pid-control.service"
EXTRA_OECONF = "--enable-configure-dbus=yes"

# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/phosphor-pid-control.git;branch=master;protocol=https"
SRCREV = "df597657fd0d1c248d1685e3b69478c80fc33461"

SRC_URI += "\
    file://0002-Remove-exception-during-restartControlLoops.patch \
    file://0003-Avoid-unnecessary-restart.patch \
    file://0001-allow-dbus-sensors-without-thresholds.patch \
    "

FILES:${PN} = "${bindir}/swampd ${bindir}/setsensor"
