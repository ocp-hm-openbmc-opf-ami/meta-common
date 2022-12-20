# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/peci-pcie;branch=master;protocol=https"
SRCREV = "60c8c917f65e78163a334db6babc8ff149c1476c"

EXTRA_OECMAKE += "-DWAIT_FOR_OS_STANDBY=1 -DUSE_RDENDPOINTCFG=1"
