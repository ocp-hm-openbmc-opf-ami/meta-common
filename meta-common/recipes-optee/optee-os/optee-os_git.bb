SUMMARY = "OP-TEE Trusted OS"
DESCRIPTION = "OPTEE OS"

LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=c1f21c4f72f372ef38a5a4aee55ec173"

PV="3.12.0+git${SRCPV}"

inherit deploy python3native

DEPENDS = "python3-pyelftools-native"
DEPENDS += "python3-pycryptodomex-native"

SRCREV = "3d47a131bca1d9ed511bfd516aa5e70269e12c1d"
SRC_URI = "git://github.com/OP-TEE/optee_os.git;nobranch=1;protocol=https \
           file://0001-allow-setting-sysroot-for-libgcc-lookup.patch \
           file://0002-Add-plat-aspeed-initial-commit.patch \
           file://0003-port-plat-aspeed-from-3.9-to-3.12.patch \
           file://0004-Revert-link.mk-add-missing-libgcc-to-ldargs.patch \
           file://0005-Add-plat-aspeed-psci_system_reset.patch \
           file://0006-core-ldelf-link-add-z-execstack.patch \
          "
S = "${WORKDIR}/git"

OPTEEMACHINE ?= "${MACHINE}"
OPTEEOUTPUTMACHINE ?= "aspeed"

EXTRA_OEMAKE = "PLATFORM=aspeed-ast2600 CFG_ARM32_core=y \
                CROSS_COMPILE_core=${HOST_PREFIX} \
                CROSS_COMPILE_ta_arm32=${HOST_PREFIX} \
                NOWERROR=1 \
                LDFLAGS= \
                LIBGCC_LOCATE_CFLAGS=--sysroot=${STAGING_DIR_HOST} \
        "

OPTEE_ARCH ?= "arm32"
OPTEE_ARCH:armv7a = "arm32"
OPTEE_ARCH:aarch64 = "arm64"

do_compile() {
    unset LDFLAGS
    oe_runmake all CFG_TEE_TA_LOG_LEVEL=1
}

do_install() {
    #install core on boot directory
    install -d ${D}${nonarch_base_libdir}/firmware/

    install -m 644 ${B}/out/arm-plat-${OPTEEOUTPUTMACHINE}/core/*.bin ${D}${nonarch_base_libdir}/firmware/
    #install TA devkit
    install -d ${D}/usr/include/optee/export-user_ta/

    for f in  ${B}/out/arm-plat-${OPTEEOUTPUTMACHINE}/export-ta_${OPTEE_ARCH}/* ; do
        cp -aR  $f  ${D}/usr/include/optee/export-user_ta/
    done
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

do_deploy() {
    install -d ${DEPLOYDIR}/optee
    for f in ${D}${nonarch_base_libdir}/firmware/*; do
        install -m 644 $f ${DEPLOYDIR}/optee/
    done
}

addtask deploy before do_build after do_install

FILES:${PN} = "${nonarch_base_libdir}/firmware/"
FILES:${PN}-dev = "/usr/include/optee"

INSANE_SKIP:${PN}-dev = "staticdev"

INHIBIT_PACKAGE_STRIP = "1"
