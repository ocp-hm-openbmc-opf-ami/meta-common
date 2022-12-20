SUMMARY = "One time automatically enable every NIC"
DESCRIPTION = "Re-enable NIC accidentally disabled by earlier BMC firmware."

S = "${WORKDIR}"
SRC_URI = "file://enable-nics.sh \
           file://enable-nics.service \
          "

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"
RDEPENDS:${PN} += "bash"

inherit systemd

FILES:${PN} += "${systemd_system_unitdir}/enable-nics.service"

do_install() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/enable-nics.service ${D}${systemd_system_unitdir}
    install -d ${D}${bindir}
    install -m 0755 ${S}/enable-nics.sh ${D}/${bindir}/enable-nics.sh
}

SYSTEMD_SERVICE:${PN} += " enable-nics.service"
