# add some configuration overrides for systemd defaults

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0002-Add-event-log-for-system-time-synchronization.patch \
            file://CVE-2023-31439.patch \
           "

# We don't support loadable modules in kernel config
PACKAGECONFIG:remove = "kmod"
# Add systemd-logind service to get shutdown inhibition support
PACKAGECONFIG:append = " logind"

do_install:append() {
        sed -i -e"s/Also=systemd-networkd-wait-online.service//g" ${D}${systemd_system_unitdir}/systemd-networkd.service
}
