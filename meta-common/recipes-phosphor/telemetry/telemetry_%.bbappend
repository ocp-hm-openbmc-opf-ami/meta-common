# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/telemetry.git;branch=master;protocol=https"
SRCREV = "a06626d1ad963f6998237a332eab9ac9392b7c7a"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Temporary patch to fix compatibility with latest bmcweb
SRC_URI += " \
             file://0001-Removed-FutureVersion-from-API.patch \
           "

EXTRA_OEMESON += " -Dmax-reports=10"
EXTRA_OEMESON += " -Dmax-reading-parameters=200"
EXTRA_OEMESON += " -Dmin-interval=1000"
EXTRA_OEMESON += " -Dservice-wants="['nv-sync.service']""
EXTRA_OEMESON += " -Dservice-after="['nv-sync.service']""

