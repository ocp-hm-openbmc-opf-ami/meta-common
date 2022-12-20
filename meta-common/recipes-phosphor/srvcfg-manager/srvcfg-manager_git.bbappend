FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# The URI is required for the autobump script but keep it commented
# to not override the upstream value
#SRC_URI = "git://github.com/openbmc/service-config-manager;branch=master;protocol=https"
SRCREV = "7a0aac564196c9edae7da3d3073b0eb3940df6f3"

SRC_URI += "file://0001-Added-PmtService-to-Service-Config-Manager.patch"
