# Enable downstream autobump
# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/x86-power-control.git;branch=master;protocol=https"
#SRCREV = "891bbde7eb6506a68b690b52b25dfa4f08904e88"
SRCREV = "edd211e4124356eb4186d227bc7f8afcea3d9cfe"

FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

SRC_URI += " \
        file://0001-Extend-VR-Watchdog-timeout.patch \
        "
