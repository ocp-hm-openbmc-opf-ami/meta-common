FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI  = "git://github.com/openbmc/host-error-monitor;branch=master;protocol=https"
SRCREV = "519f2cd6284a402113434b4e23c5908ed49e5d5c"

EXTRA_OECMAKE = "-DYOCTO=1"
