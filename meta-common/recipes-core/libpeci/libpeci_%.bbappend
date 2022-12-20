# Enable downstream autobump
# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/libpeci;branch=master;protocol=https"
SRCREV = "a89be7669d31507388610d5300f7f442cf945f01"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
        file://0001-Enable-64-bit-RdPkgConfig-and-WrPkgConfig-transfers.patch \
        file://0003-Add-pre-release-CPUModel-definitions.patch \
"
