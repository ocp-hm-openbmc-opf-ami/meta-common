SUMMARY = "C++ bindings PMT API"
DESCRIPTION = "C++ bindings PMT API"

inherit pkgconfig meson

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Telemetry;md5=858e10cab31872ff374c48e5240d566a"

SRC_URI = "git://git@github.com/intel-bmc/firmware.bmc.openbmc.libraries.libpmt.git;protocol=ssh;branch=main"
SRCREV = "cb5c0651105e4f5ca17df52d4b11c3561e2ca80d"
PV = "1.0+git${SRCPV}"

S = "${WORKDIR}/git"

DEPENDS += " boost \
             mctpwplus"

EXTRA_OEMESON:append = " \
        -Dtests=disabled \
        -Dexamples=disabled \
        --buildtype=minsize \
        "
