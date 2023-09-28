FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS += "nlohmann-json boost"

# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/phosphor-networkd;branch=master;protocol=https"
SRCREV = "7af5b73d151dbc8504d77c504b3de654d72735fa"

SRC_URI += "file://0003-Adding-channel-specific-privilege-to-network.patch \
           "

EXTRA_OEMESON:append = " -Ddefault-ipv6-accept-ra=true"
EXTRA_OEMESON:append = " -Dhyp-nw-config=false"
EXTRA_OEMESON:append = " -Dpersist-mac=false"
