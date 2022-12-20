SUMMARY = "Configure USB Type C controller"
DESCRIPTION = "Configure USB Type C CC controller which requires basic initialization on every G3 to S5 cycle"

S = "${WORKDIR}"
SRC_URI = " \
   file://configure-usb-c.sh \
   file://configure-usb-c.service \
   "

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"
RDEPENDS:${PN} += "bash"

inherit systemd

FILES:${PN} += "${systemd_system_unitdir}/configure-usb-c.service"

do_install:append() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/configure-usb-c.sh ${D}/${bindir}/configure-usb-c.sh
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/configure-usb-c.service ${D}${base_libdir}/systemd/system
}

SYSTEMD_SERVICE:${PN} = "configure-usb-c.service"
