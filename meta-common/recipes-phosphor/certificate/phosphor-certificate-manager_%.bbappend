# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/phosphor-certificate-manager;branch=master;protocol=https"
SRCREV = "23778dd40421d6cfe73c4774442e901f66d44b33"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0001-Add-certificate-key-length-check.patch \
    "

EXTRA_OEMESON += " -Dallow-expired=disabled"
