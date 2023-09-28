SUMMARY = "Check for host in reset to disable the NCSI iface"
DESCRIPTION = "If the host is in reset, the NCSI NIC will not be \
               available, so this will manually disable the NIC"

FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

PV = "1.0"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

SRC_URI = "\
    file://check-for-host-in-reset \
    file://${BPN}.service \
    "

RDEPENDS:${PN} += "bash"

inherit obmc-phosphor-systemd

SYSTEMD_SERVICE:${PN} += "${BPN}.service"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/check-for-host-in-reset ${D}/${bindir}/check-for-host-in-reset

}
