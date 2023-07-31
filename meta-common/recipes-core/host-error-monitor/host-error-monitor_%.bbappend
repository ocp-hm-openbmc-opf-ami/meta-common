FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI  = "git://github.com/openbmc/host-error-monitor;branch=master;protocol=https"
SRCREV = "03ed41b37b9feba12d8dcf42f5580557b9e0f13f"

SRC_URI += " \
    file://ras-offload/0001-Add-ERR0-monitor-for-RAS.patch \
    "

EXTRA_OECMAKE = "-DYOCTO=1 -DLIBPECI=1"
