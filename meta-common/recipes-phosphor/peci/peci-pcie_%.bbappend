# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/peci-pcie;branch=master;protocol=https"
SRCREV = "4fe704c4b2a6c79879922e3875494b7bbe6155d5"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0001-Skip-SPR-CPU-buses.patch \
    "

EXTRA_OECMAKE += "-DWAIT_FOR_OS_STANDBY=1 -DUSE_RDENDPOINTCFG=1"
