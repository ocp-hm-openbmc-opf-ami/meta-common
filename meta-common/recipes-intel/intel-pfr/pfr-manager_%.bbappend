# Enable downstream autobump
# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/pfr-manager;branch=master;protocol=https"
SRCREV = "701084454224c4f30335293c40d03d8f046a8f39"
inherit pkgconfig
DEPENDS += " libgpiod \
           "
