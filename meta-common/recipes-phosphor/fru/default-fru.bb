SUMMARY = "Default Fru"
DESCRIPTION = "Builds a default FRU file at runtime based on board ID"

inherit obmc-phosphor-systemd
inherit cmake

SRC_URI = "file://checkFru.sh;subdir=${BP} \
           file://decodeBoardID.sh;subdir=${BP} \
           file://mkfru.cpp;subdir=${BP} \
           file://CMakeLists.txt;subdir=${BP} \
           "
SYSTEMD_SERVICE:${PN} = "SetBaseboardFru.service"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

RDEPENDS:${PN} = "bash"

do_install:append() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/checkFru.sh ${D}${bindir}/checkFru.sh
    install -m 0755 ${S}/decodeBoardID.sh ${D}${bindir}/decodeBoardID.sh
}
