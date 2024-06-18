SUMMARY = "libspdm:dmtf"
DESCRIPTION = "Import the implementation of libspdm"
PR = "r1"

inherit pkgconfig cmake

DEPENDS += " \
            openssl\
            "
LICENSE = "DMTF"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=d74819f195a01f205577d2a96382b4f7"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI = "gitsm://github.com/DMTF/libspdm.git;protocol=https;nobranch=1 \
            file://0001-CMakeLists.txt.patch \
            file://0002-create-libspdm.patch \
            file://0003-Add-libspdm.pc.in.patch \
            "

SRCREV = "884cf00dd4a3ab0867788182616079fdfd0420b6"

S = "${WORKDIR}/git"

OBMCGCC_OPTION = "${CC}"
OBMCGCC_OPTION:remove = "arm-openbmc-linux-gnueabi-gcc"

EXTRA_OECMAKE:append = " -DARCH=arm -DCMAKE_SYSTEM_NAME=Linux -DTOOLCHAIN=OPENBMC_GCC -DTARGET=Release -DCRYPTO=openssl -DCOMPILED_LIBCRYPTO_PATH="./os_stub/cryptlib_openssl" -DCOMPILED_LIBSSL_PATH="./os_stub/openssllib" -DMDEPKG_NDEBUG=1 -DOBMCGCCOPTION='${OBMCGCC_OPTION}' "
