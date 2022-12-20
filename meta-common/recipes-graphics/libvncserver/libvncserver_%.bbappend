FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

# Use the latest to support obmc-ikvm properly
# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/LibVNC/libvncserver;branch=master;protocol=https"
SRCREV = "88e05c533fe37ef31cb66f1406820e3dbe2803ce"
