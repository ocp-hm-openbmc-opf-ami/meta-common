# Ref. openbmc-meta-intel/meta-common/recipes-core/systemd/systemd_%.bbappend
# add some configuration overrides for at-scale-debug defaults
# file://0002-Add-event-log-for-system-time-synchronization.patch

# 2024/07/06 ASD upgrade 1.5.4, below old patch files, 
# will integrate to a new patch, naming "001_ASD_integration.patch"
# file://001_ami-asd-dbus.patch 
# file://002_default-asdCertificate-change.patch


FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://001_ASD-integration.patch \
"
