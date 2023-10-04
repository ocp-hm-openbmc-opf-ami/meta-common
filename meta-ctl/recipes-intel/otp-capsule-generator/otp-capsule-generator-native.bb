SUMMARY = "Intel(R) Platform Firmware OTP Capsule Generator Native"
DESCRIPTION = "Image OTP Capsule Generation tool for building Intel(R) image"


LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

inherit native

DEPENDS = "python3-native python3-requests-native python3-urllib3-native "

SRC_URI = " \
           file://otp_capsule_generator.py \
           "

do_install () {
    install -d ${D}${bindir}
    install -m 775 ${WORKDIR}/otp_capsule_generator.py ${D}${bindir}/otp-capsule-generator
}
