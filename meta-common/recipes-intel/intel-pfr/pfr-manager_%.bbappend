# Enable downstream autobump
# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/pfr-manager;branch=master;protocol=https"
SRCREV = "48935a4343cbb81e43f37a9442d72905442300f9"
inherit pkgconfig
DEPENDS += " libgpiod \
           "
