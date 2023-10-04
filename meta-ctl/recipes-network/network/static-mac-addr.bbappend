FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

SRC_URI:append = " file://Skip-Unique-Hostname.conf"

SYSTEMD_OVERRIDE:${PN} += "Skip-Unique-Hostname.conf:static-mac-addr.service.d/10-Skip-Unique-Hostname.conf"