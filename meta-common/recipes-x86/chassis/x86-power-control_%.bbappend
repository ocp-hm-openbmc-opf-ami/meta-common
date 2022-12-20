# Enable downstream autobump
# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/x86-power-control.git;branch=master;protocol=https"
SRCREV = "fa2b6448a5169b5e981a24ae4ca0c03b80a07149"

FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

SRC_URI += " \
        file://0001-Extend-VR-Watchdog-timeout.patch \
        "
