SUMMARY = "openbmc trusted applications"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-FWSEC;md5=8ad5886152d8fa09daa41fbe51fff047"

DEPENDS = "optee-client optee-os python3-pycryptodomex-native"

inherit python3native

SRC_URI = "git://git@github.com/intel-collab/firmware.bmc.openbmc.applications.trusted-application.git;protocol=ssh;nobranch=1 \
          "

SRCREV = "c32f8b234f232abd87007059d7ade5216aec0215"

S = "${WORKDIR}/git"

OPTEE_CLIENT_EXPORT = "${STAGING_DIR_HOST}${prefix}"
TEEC_EXPORT = "${STAGING_DIR_HOST}${prefix}"
TA_DEV_KIT_DIR = "${STAGING_INCDIR}/optee/export-user_ta"

EXTRA_OEMAKE = " TA_DEV_KIT_DIR=${TA_DEV_KIT_DIR} \
                 OPTEE_CLIENT_EXPORT=${OPTEE_CLIENT_EXPORT} \
                 TEEC_EXPORT=${TEEC_EXPORT} \
                 HOST_CROSS_COMPILE=${TARGET_PREFIX} \
                 TA_CROSS_COMPILE=${TARGET_PREFIX} \
                 V=1 \
               "

do_compile() {
    oe_runmake
}

do_install () {
    mkdir -p ${D}${nonarch_base_libdir}/optee_armtz
    mkdir -p ${D}${bindir}
    mkdir -p ${D}${includedir}
    install -D -p -m0755 ${S}/out/ca/* ${D}${bindir}
    install -D -p -m0444 ${S}/out/ta/* ${D}${nonarch_base_libdir}/optee_armtz
    install -D -p -m0444 ${S}/out/include/* ${D}${includedir}
}

FILES:${PN} += "${nonarch_base_libdir}/optee_armtz/"
FILES:${PN} += "${includedir}/*"

INSANE_SKIP:${PN} += "ldflags"

# Imports machine specific configs from staging to build
PACKAGE_ARCH = "${MACHINE_ARCH}"
