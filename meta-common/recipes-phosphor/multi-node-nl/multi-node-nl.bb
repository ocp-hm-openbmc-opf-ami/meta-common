SUMMARY = "Multi-node Non-legacy"
DESCRIPTION = "New systemd target for non-legacy nodes on multi-node platform"

inherit systemd

SYSTEMD_SERVICE:${PN} = "multi-node-nl.target"
SYSTEMD_SERVICE:${PN} += "nonLegacyNode.service"

S = "${WORKDIR}"
SRC_URI = "file://multi-node-nl.target \
           file://nonLegacyNode.service \
           file://nonLegacyNode.sh \
          "

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

RDEPENDS:${PN} = "bash"

do_install:append() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/nonLegacyNode.sh ${D}/${bindir}/nonLegacyNode.sh

    install -d ${D}${base_libdir}/systemd/system
    install -m 0644 ${S}/multi-node-nl.target ${D}${base_libdir}/systemd/system
    install -m 0644 ${S}/nonLegacyNode.service ${D}${base_libdir}/systemd/system
}
