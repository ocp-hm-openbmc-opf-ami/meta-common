SUMMARY = "Intel PFR image manifest and image signing keys"
DESCRIPTION = "This copies PFR image generation scripts and image signing keys to staging area"

PR = "r1"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

inherit native

DEPENDS += " intel-pfr-signing-utility-native \
             "

SRC_URI = " \
           file://pfr_image.py \
          "

do_install () {
        bbplain "Copying intel pfr image generation scripts and image signing keys"

        install -d ${D}${bindir}
        install -d ${D}/${datadir}/pfrconfig
        install -m 775 ${WORKDIR}/pfr_image.py ${D}${bindir}/pfr_image.py
}

