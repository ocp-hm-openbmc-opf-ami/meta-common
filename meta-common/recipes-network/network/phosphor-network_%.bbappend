FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/phosphor-networkd;branch=master;protocol=https"
SRCREV = "a4c18d4e50b74f1c19ebdfaaf7073ab89d6524bb"

SRC_URI += "file://0003-Adding-channel-specific-privilege-to-network.patch \
           "

EXTRA_OEMESON:append = " -Ddefault-ipv6-accept-ra=true"
EXTRA_OEMESON:append = " -Dhyp-nw-config=false"
EXTRA_OEMESON:append = " -Dpersist-mac=false"
