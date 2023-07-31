FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

# Use the latest to support obmc-ikvm properly
# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/LibVNC/libvncserver;branch=master;protocol=https"
SRCREV = "d62002e46fb4a4a16573ff9b8a37d114443aa059"
