FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/phosphor-networkd;branch=master;protocol=https"
SRCREV = "89d734b9886c40fa530f9fd6e67eb87b6955ec08"

SRC_URI += "file://0003-Adding-channel-specific-privilege-to-network.patch \
           "

EXTRA_OEMESON:append = " -Ddefault-ipv6-accept-ra=true"
EXTRA_OEMESON:append = " -Dhyp-nw-config=false"
EXTRA_OEMESON:append = " -Dpersist-mac=false"
