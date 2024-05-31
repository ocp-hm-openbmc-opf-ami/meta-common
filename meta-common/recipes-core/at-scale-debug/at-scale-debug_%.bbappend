# Ref. openbmc-meta-intel/meta-common/recipes-core/systemd/systemd_%.bbappend
# add some configuration overrides for at-scale-debug defaults
# file://0002-Add-event-log-for-system-time-synchronization.patch

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

#SRC_URI += " \
#    file://001_ami-asd-dbus.patch \
#    file://002_default-asdCertificate-change.patch \
#"
