# Enable downstream autobump
# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/libpeci;branch=master;protocol=https"
SRCREV = "0bff6858af8405b307cdf5fdca46a008f0f52090"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
        file://99-peci.rules \
        file://0001-Enable-64-bit-RdPkgConfig-and-WrPkgConfig-transfers.patch \
        file://0002-Add-PECI-Telemetry-command.patch \
        file://0003-Add-single-dev-peci-i3c-node-abstraction.patch \
"

do_install:append() {
    install -d ${D}${libdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/99-peci.rules ${D}${libdir}/udev/rules.d
}

PACKAGECONFIG:append:intel = " dbus-raw-peci"
