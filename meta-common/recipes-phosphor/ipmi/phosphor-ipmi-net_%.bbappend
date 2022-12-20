inherit useradd

USERADD_PACKAGES = "${PN}"
# add a group called ipmi
GROUPADD_PARAM:${PN} = "ipmi "

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Enable downstream autobump to fix sync build, can be removed later
# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI += "git://github.com/openbmc/phosphor-net-ipmid;branch=master;protocol=https"
SRCREV = "02d13a26b6f60dbb41ac38aed3d12a99555fc302"

SRC_URI += " file://10-nice-rules.conf \
             file://0001-Enable-UART-mux-setting-before-SOL-activation.patch \
             file://0006-Modify-dbus-namespace-of-chassis-control-for-guid.patch \
             file://0012-rakp12-Add-username-to-SessionInfo-interface.patch \
           "

do_install:append() {
    mkdir -p ${D}${sysconfdir}/systemd/system/phosphor-ipmi-net@.service.d/
    install -m 0644 ${WORKDIR}/10-nice-rules.conf ${D}${sysconfdir}/systemd/system/phosphor-ipmi-net@.service.d/
}

# Add optee-ast2600 support, if enabled
OPTEE_SRC_URI = " \
                  file://1001-SecureEnclave-POC-RAKP-use-ipmi-pass-TA.patch \
                  file://1002-Move-OPTEE-secure-code.patch \
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
