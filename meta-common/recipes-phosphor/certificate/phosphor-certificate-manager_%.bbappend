# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/phosphor-certificate-manager;branch=master;protocol=https"
SRCREV = "223e460421eebb1c598d9285b0cb01f1150fa50d"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0001-Add-certificate-key-length-check.patch \
    "
