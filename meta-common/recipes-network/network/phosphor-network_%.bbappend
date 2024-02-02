FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/phosphor-networkd;branch=master;protocol=https"
SRCREV = "1f0052f8e783801288e6701e7b7fd34454a04a3c"

SRC_URI += "file://0003-Adding-channel-specific-privilege-to-network.patch \
           "

EXTRA_OEMESON:append = " -Ddefault-ipv6-accept-ra=true"
EXTRA_OEMESON:append = " -Dhyp-nw-config=false"
EXTRA_OEMESON:append = " -Dpersist-mac=false"
