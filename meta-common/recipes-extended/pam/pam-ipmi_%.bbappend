FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
OPTEE_SRC_URI = " \
                  file://0001-Implement-OPTEE-Security-Feature.patch \
                "
SRC_URI += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'optee-ast2600', OPTEE_SRC_URI, '', d)}"

OPTEE_CLIENT_EXPORT = "${STAGING_DIR_HOST}${prefix}"
TEEC_EXPORT = "${STAGING_DIR_HOST}${prefix}"
TA_DEV_KIT_DIR = "${STAGING_INCDIR}/optee/export-user_ta"

TARGET_CFLAGS += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'optee-ast2600', '-DHAS_OPTEE', '', d)}"
TARGET_CFLAGS += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'optee-ast2600', '-Wall -I$(TEEC_EXPORT)/include -I./include', '', d)}"
TARGET_LDFLAGS += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'optee-ast2600', '-lteec -L${TEEC_EXPORT}/lib', '', d)}"

OPTEE_EXTRA_OEMAKE = " TA_DEV_KIT_DIR=${TA_DEV_KIT_DIR} \
                 OPTEE_CLIENT_EXPORT=${OPTEE_CLIENT_EXPORT} \
                 TEEC_EXPORT=${TEEC_EXPORT} \
                 HOST_CROSS_COMPILE=${TARGET_PREFIX} \
                 TA_CROSS_COMPILE=${TARGET_PREFIX} \
                 V=1 \
               "
EXTRA_OEMAKE += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'optee-ast2600', OPTEE_EXTRA_OEMAKE, '', d)}"

DEPENDS += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'optee-ast2600', 'optee-client', '', d)}"
DEPENDS += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'optee-ast2600', 'optee-user-ta', '', d)}"

do_install:append () {
# Remove ipmi_pass from image, if debug-tweaks is not enabled
    ${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', '', 'rm ${D}/${sysconfdir}/ipmi_pass', d)}
}
