FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

# Enable downstream autobump
# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/phosphor-watchdog;branch=master;protocol=https"
SRCREV = "fcc00392e8f70c2fc8f911595629869e2f6c6cfb"

SRC_URI += "file://0001-Customize-phosphor-watchdog-for-Intel-platforms.patch \
           "

# Remove the override to keep service running after DC cycle
SYSTEMD_OVERRIDE:${PN}:remove = "poweron.conf:phosphor-watchdog@poweron.service.d/poweron.conf"
SYSTEMD_SERVICE:${PN} = "phosphor-watchdog.service"
