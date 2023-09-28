# Enable downstream autobump
# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/x86-power-control.git;branch=master;protocol=https"
SRCREV = "cc037b89fbfdf1c33dbf4461d5670e5395e4b19c"

FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

SRC_URI += " \
        file://0001-Extend-VR-Watchdog-timeout.patch \
        "
