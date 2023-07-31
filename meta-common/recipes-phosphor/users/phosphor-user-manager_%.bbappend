FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/phosphor-user-manager;branch=master;protocol=https"
SRCREV = "601d3db44097d89a7d24ae287e8bbe72e7e92d5d"

EXTRA_OEMESON += "${@bb.utils.contains('IMAGE_FEATURES', 'debug-tweaks', '-Droot_user_mgmt=enabled', '-Droot_user_mgmt=disabled', d)}"

SRC_URI += " \
             file://0002-Use-groupmems-instead-of-getgrnam_r-due-to-overlay.patch \
           "

FILES:${PN} += "${datadir}/dbus-1/system.d/phosphor-nslcd-cert-config.conf"
FILES:${PN} += "/usr/share/phosphor-certificate-manager/nslcd"
FILES:${PN} += "\
    /lib/systemd/system/multi-user.target.wants/phosphor-certificate-manager@nslcd.service"
