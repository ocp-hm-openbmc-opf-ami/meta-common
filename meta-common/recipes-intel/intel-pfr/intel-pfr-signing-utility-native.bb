SUMMARY = "Intel(R) Platform Firmware Resilience Signing Utility"
DESCRIPTION = "Image signing tool for building Intel(R) PFR image"

inherit cmake native

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

DEPENDS = "pkgconfig-native openssl-native libxml2-native "

SRC_URI = "git://git@github.com/intel-collab/firmware.bmc.openbmc.applications.intel-pfr-signing-utility.git;protocol=ssh;branch=main"

SRCREV = "7ad7cb3f3d7f408fd9ac454c242e77c8fbc6d61b"

S = "${WORKDIR}/git"

do_install:append() {
   install -d ${D}/${bindir}
   install -m 775 ${B}/intel-pfr-signing-utility ${D}/${bindir}
}
