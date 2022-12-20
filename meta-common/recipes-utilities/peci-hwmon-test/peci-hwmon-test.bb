SUMMARY = "PECI hwmon test tool"
DESCRIPTION = "command line python tool for testing PECI hwmon"

SRC_URI = "\
    file://peci-hwmon-test.py \
    "
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

RDEPENDS:${PN} += "python"

S = "${WORKDIR}"

do_compile () {
}

do_install () {
    install -d ${D}/${bindir}
    install -m 0755 ${WORKDIR}/peci-hwmon-test.py ${D}/${bindir}
}

