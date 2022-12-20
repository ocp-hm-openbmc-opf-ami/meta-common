# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/ipmbbridge.git;branch=master;protocol=https"
SRCREV = "8978a5a81cddfa86423cd2a0c2a8154858df0151"
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://0001-Add-dbus-method-SlotIpmbRequest.patch \
           file://0002-Add-log-count-limitation-to-requestAdd.patch \
           file://0003-Fix-for-clearing-outstanding-requests.patch \
           file://ipmb-channels.json \
           "

do_install:append() {
    install -D ${WORKDIR}/ipmb-channels.json \
               ${D}/usr/share/ipmbbridge
}
