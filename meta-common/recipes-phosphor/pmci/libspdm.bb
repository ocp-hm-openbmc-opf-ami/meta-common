SUMMARY = "libspdm:dmtf"
DESCRIPTION = "Import the implementation of libspdm"
PR = "r1"

inherit pkgconfig cmake

DEPENDS += " \
            openssl\
            "
LICENSE = "DMTF"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=d6578ce21490af4b24f9ed3392884549"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI = "gitsm://github.com/DMTF/libspdm.git;protocol=https;nobranch=1 \
            file://0001-CMakeLists.txt.patch \
            file://0002-create-libspdm.patch \
            file://0003-Add-libspdm.pc.in.patch \
            "

SRCREV = "d3f5c697319b5dfeee387eeabb1f644221ff0e7d"

S = "${WORKDIR}/git"

OBMCGCC_OPTION = "${CC}"
OBMCGCC_OPTION:remove = "arm-openbmc-linux-gnueabi-gcc"

EXTRA_OECMAKE:append = " -DARCH=arm -DCMAKE_SYSTEM_NAME=Linux -DTOOLCHAIN=OPENBMC_GCC -DTARGET=Release -DCRYPTO=openssl -DCOMPILED_LIBCRYPTO_PATH="./os_stub/cryptlib_openssl" -DCOMPILED_LIBSSL_PATH="./os_stub/openssllib" -DMDEPKG_NDEBUG=1 -DOBMCGCCOPTION='${OBMCGCC_OPTION}' "
