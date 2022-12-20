FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

#SYSTEMD_SUBSTITUTIONS_remove = "KCS_DEVICE:${KCS_DEVICE}:${DBUS_SERVICE_${PN}}"

# Default kcs device is ipmi-kcs3; this is SMS.
# Add SMM kcs device instance

# Replace the '-' to '_', since Dbus object/interface names do not allow '-'.
KCS_DEVICE = "ipmi_kcs3"
SMM_DEVICE = "ipmi_kcs4"
SYSTEMD_SERVICE:${PN}:append = " ${PN}@${SMM_DEVICE}.service "

# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/kcsbridge.git;branch=master;protocol=https"
SRCREV = "314604455606f9baee1e4f5d7fe645d1ebf3c295"

SRC_URI += "file://99-ipmi-kcs.rules"

do_install:append() {
    install -d ${D}${base_libdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/99-ipmi-kcs.rules ${D}${base_libdir}/udev/rules.d/
}
