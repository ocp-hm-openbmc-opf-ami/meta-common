FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

# Use the latest to support obmc-ikvm properly
# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/LibVNC/libvncserver;branch=master;protocol=https"
SRCREV = "7fda996b43a57da5aaaecaa5cb489c7e0ccc3dff"
