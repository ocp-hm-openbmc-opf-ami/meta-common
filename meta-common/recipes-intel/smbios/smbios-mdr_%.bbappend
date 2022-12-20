FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Enable downstream autobump
# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/smbios-mdr.git;branch=master;protocol=https"
SRCREV = "3e6be2eea132571ec4cae82cd16cdec6c9170560"
DEPENDS += " \
    nlohmann-json \
    "
