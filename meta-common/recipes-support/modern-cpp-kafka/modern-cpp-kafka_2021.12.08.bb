SUMMARY = "C++ wrapper on librdkafka"
HOMEPAGE = "https://github.com/morganstanley/modern-cpp-kafka"
SECTION = "libs"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

inherit pkgconfig

DEPENDS = "librdkafka (= 1.7.0)"

BBCLASSEXTEND = "native nativesdk"
BRANCH = "main"
SRCREV = "12bae9704bb1df45f18b62cf90b8d6d839fd4b6a"
SRC_URI = "git://github.com/morganstanley/modern-cpp-kafka;branch=${BRANCH} \
           file://add-pkgconfig-file.patch \
           "
S = "${WORKDIR}/git"

do_install () { 
    install -d ${D}${includedir}
    cp -r ${S}/include/kafka ${D}${includedir}
    install -d ${D}${libdir}/pkgconfig
    install -m 0644 ${S}/lib/pkgconfig/modern-cpp-kafka.pc ${D}${libdir}/pkgconfig/
}
