SUMMARY = "Intel(R) Platform Firmware External Signing Utility Native"
DESCRIPTION = "Image external signing tool for building Intel(R) image"


LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

inherit native

DEPENDS = "python3-native python3-requests-native python3-urllib3-native "

SRC_URI = " \
           file://external_signing_utility.py \
           "

do_install () {
        bbwarn "Missing keys to sign BMC image."  
        bbwarn "Building BMC image with Auto Generated keys."
        install -d ${D}${bindir}
        install -m 775 ${WORKDIR}/external_signing_utility.py ${D}${bindir}/external-signing-utility
}
