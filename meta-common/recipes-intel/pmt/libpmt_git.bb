SUMMARY = "C++ bindings PMT API"
DESCRIPTION = "C++ bindings PMT API"

inherit pkgconfig meson

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Telemetry;md5=858e10cab31872ff374c48e5240d566a"

SRC_URI = "git://git@github.com/intel-collab/firmware.bmc.openbmc.libraries.libpmt.git;protocol=ssh;branch=main"
SRCREV = "5e6ba892a232b36aa4e7867523a5a9ac6e0c68c8"
PV = "1.0+git${SRCPV}"

S = "${WORKDIR}/git"

DEPENDS += " boost \
             mctpwplus"

EXTRA_OEMESON:append = " \
        -Dtests=disabled \
        -Dexamples=disabled \
        --buildtype=minsize \
        "
