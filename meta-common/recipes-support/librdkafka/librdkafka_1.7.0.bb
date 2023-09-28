SUMMARY = "the Apache Kafka C/C++ client library"
HOMEPAGE = "http://apr.apache.org/"
SECTION = "libs"

LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=2be8675acbfdac48935e73897af5f646"

DEPENDS = "zlib openssl zstd"

inherit cmake

FILES:${PN} += "${datadir}"
EXTRA_OECMAKE += "-DRDKAFKA_BUILD_EXAMPLES=OFF -DRDKAFKA_BUILD_TESTS=OFF"

BRANCH = "master"
SRCREV = "77a013b7a2611f7bdc091afa1e56b1a46d1c52f5"
SRC_URI = "git://github.com/edenhill/librdkafka;branch=${BRANCH}"

S = "${WORKDIR}/git"
