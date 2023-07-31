FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/sdbusplus;branch=master;protocol=https"
SRCREV = "3b451ad4b07f6f88d4d2924e99eddfb7bfb34cce"

SRC_URI += " \
             file://0002-Skip-decoding-some-dbus-identifiers.patch \
           "
