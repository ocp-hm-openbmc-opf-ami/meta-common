FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/sdbusplus;branch=master;protocol=https"
SRCREV = "5d26ec9ef5e46b93fe629fea55f1f9af8da7ded0"

SRC_URI += " \
             file://0001-Revert-server-Check-return-code-for-sd_bus_add_objec.patch \
             file://0002-Skip-decoding-some-dbus-identifiers.patch \
           "
