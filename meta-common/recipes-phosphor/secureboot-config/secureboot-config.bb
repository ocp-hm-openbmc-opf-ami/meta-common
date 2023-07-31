SUMMARY = "intel secure keys for Secure boot Feature."
DESCRIPTION = "Supported RSA2048 SHA256 and RSA4096 SHA512"
PR = "r0"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

inherit python3native
inherit allarch

SRC_URI = " \
    file://configs;subdir=${S} \
    "

DEPENDS += " python3-requests-native python3-urllib3-native"
RDEPENDS:${PN} += "bash"

do_patch[noexec] = "1"
do_configure[noexec] = "1"
do_compile[noexec] = "1"

KEY_INSTALL_DIR = "${D}${datadir}/secureboot-config/ast2600/security/key"

do_install[network] = "1"
do_install() {
    install -d ${D}${datadir}
    install -d ${D}${datadir}/secureboot-config
    install -d ${D}${datadir}/secureboot-config/ast2600
    install -d ${D}${datadir}/secureboot-config/ast2600/security
    install -d ${D}${datadir}/secureboot-config/ast2600/security/otp
    install -d ${D}${datadir}/secureboot-config/ast2600/security/key

    install -m 0644 ${S}/configs/key/*.bin \
        ${D}${datadir}/secureboot-config/ast2600/security/key
    install -m 0644 ${S}/configs/otp/* \
        ${D}${datadir}/secureboot-config/ast2600/security/otp

    install -m 0755 ${S}/configs/*.py \
        ${D}${datadir}/secureboot-config
}

do_install[depends] += " \
                         external-signing-utility-native:do_populate_sysroot \
                         "

BBCLASSEXTEND = "native"
