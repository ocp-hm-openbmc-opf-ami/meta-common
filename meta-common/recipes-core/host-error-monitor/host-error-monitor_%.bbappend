FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI  = "git://github.com/openbmc/host-error-monitor;branch=master;protocol=https"
SRCREV = "8b7c55eb3b485ffd5d8497c1060033076a2f43fc"
inherit pkgconfig

EXTRA_OECMAKE = "-DYOCTO=1 -DLIBPECI=1 -DCRASHDUMP=1"

# RAS Offload features:
SRC_URI += " \
    file://ras-offload/0001-Add-ERR0-monitor-for-RAS.patch \
    "
