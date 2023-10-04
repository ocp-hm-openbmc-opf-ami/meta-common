SUMMARY = "BMC Assisted Fru Isolation"
DESCRIPTION = "Isolates failing FRU from crashdump."
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-ACD;md5=eed054adf11169b8a51e82ece595b6c6"
SRCREV = "a523c9c6dd873573a72ee6cf73bd04f9e0bba87f"
PV = "1.0+git${SRCPV}"
SRC_URI = "git://git@github.com/intel-bmc/firmware.bmc.openbmc.applications.bmc-assisted-fru-isolation.git;branch=main;protocol=ssh"
S = "${WORKDIR}/git"
DEPENDS = "nlohmann-json"

do_install() {

        install -D -m 0644 ${S}/include/utils.hpp ${D}${includedir}/bafi/utils.hpp
        install -D -m 0644 ${S}/include/aer.hpp ${D}${includedir}/bafi/aer.hpp
        install -D -m 0644 ${S}/include/tsc.hpp ${D}${includedir}/bafi/tsc.hpp
        install -D -m 0644 ${S}/include/tor_defs.hpp ${D}${includedir}/bafi/tor_defs.hpp
        install -D -m 0644 ${S}/include/tor_defs_icx.hpp ${D}${includedir}/bafi/tor_defs_icx.hpp
        install -D -m 0644 ${S}/include/tor_defs_cpx.hpp ${D}${includedir}/bafi/tor_defs_cpx.hpp
        install -D -m 0644 ${S}/include/tor_defs_skx.hpp ${D}${includedir}/bafi/tor_defs_skx.hpp
        install -D -m 0644 ${S}/include/tor_defs_spr.hpp ${D}${includedir}/bafi/tor_defs_spr.hpp
        install -D -m 0644 ${S}/include/mca_defs.hpp ${D}${includedir}/bafi/mca_defs.hpp
        install -D -m 0644 ${S}/include/mca_icx.hpp ${D}${includedir}/bafi/mca_icx.hpp
        install -D -m 0644 ${S}/include/mca_cpx.hpp ${D}${includedir}/bafi/mca_cpx.hpp
        install -D -m 0644 ${S}/include/mca_skx.hpp ${D}${includedir}/bafi/mca_skx.hpp
        install -D -m 0644 ${S}/include/mca_spr.hpp ${D}${includedir}/bafi/mca_spr.hpp
        install -D -m 0644 ${S}/include/mca_icx_defs.hpp ${D}${includedir}/bafi/mca_icx_defs.hpp
        install -D -m 0644 ${S}/include/mca_cpx_defs.hpp ${D}${includedir}/bafi/mca_cpx_defs.hpp
        install -D -m 0644 ${S}/include/mca_skx_defs.hpp ${D}${includedir}/bafi/mca_skx_defs.hpp
        install -D -m 0644 ${S}/include/mca_spr_defs.hpp ${D}${includedir}/bafi/mca_spr_defs.hpp
        install -D -m 0644 ${S}/include/cpu.hpp ${D}${includedir}/bafi/cpu.hpp
        install -D -m 0644 ${S}/include/cpu_factory.hpp ${D}${includedir}/bafi/cpu_factory.hpp
        install -D -m 0644 ${S}/include/tor_whitley.hpp ${D}${includedir}/bafi/tor_whitley.hpp
        install -D -m 0644 ${S}/include/tor_purley.hpp ${D}${includedir}/bafi/tor_purley.hpp
        install -D -m 0644 ${S}/include/tor_eaglestream.hpp ${D}${includedir}/bafi/tor_eaglestream.hpp
        install -D -m 0644 ${S}/include/tor_whitley_defs.hpp ${D}${includedir}/bafi/tor_whitley_defs.hpp
        install -D -m 0644 ${S}/include/tor_factory.hpp ${D}${includedir}/bafi/tor_factory.hpp
        install -D -m 0644 ${S}/include/tor_icx.hpp ${D}${includedir}/bafi/tor_icx.hpp
        install -D -m 0644 ${S}/include/tor_cpx.hpp ${D}${includedir}/bafi/tor_cpx.hpp
        install -D -m 0644 ${S}/include/tor_skx.hpp ${D}${includedir}/bafi/tor_skx.hpp
        install -D -m 0644 ${S}/include/tor_spr.hpp ${D}${includedir}/bafi/tor_spr.hpp
        install -D -m 0644 ${S}/include/pcilookup.hpp ${D}${includedir}/bafi/pcilookup.hpp
        install -D -m 0644 ${S}/include/mca.hpp ${D}${includedir}/bafi/mca.hpp
        install -D -m 0644 ${S}/include/summary.hpp ${D}${includedir}/bafi/summary.hpp
        install -D -m 0644 ${S}/include/generic_report.hpp ${D}${includedir}/bafi/generic_report.hpp
        install -D -m 0644 ${S}/include/report.hpp ${D}${includedir}/bafi/report.hpp
        install -D -m 0644 ${S}/include/triage.hpp ${D}${includedir}/bafi/triage.hpp
        install -D -m 0644 ${S}/include/tor_gnr.hpp ${D}${includedir}/bafi/tor_gnr.hpp
        install -D -m 0644 ${S}/include/tor_defs_bhs.hpp ${D}${includedir}/bafi/tor_defs_bhs.hpp
        install -D -m 0644 ${S}/include/tor_birchstream.hpp ${D}${includedir}/bafi/tor_birchstream.hpp
        install -D -m 0644 ${S}/include/summary_field.hpp ${D}${includedir}/bafi/summary_field.hpp
        install -D -m 0644 ${S}/include/mca_gnr_defs.hpp ${D}${includedir}/bafi/mca_gnr_defs.hpp
        install -D -m 0644 ${S}/include/mca_gnr.hpp ${D}${includedir}/bafi/mca_gnr.hpp
        install -D -m 0644 ${S}/include/mca_decode_utils.hpp ${D}${includedir}/bafi/mca_decode_utils.hpp
        install -D -m 0644 ${S}/include/retry_rd_spr.hpp ${D}${includedir}/bafi/retry_rd_spr.hpp
        install -D -m 0644 ${S}/include/retry_rd_icx.hpp ${D}${includedir}/bafi/retry_rd_icx.hpp
        install -D -m 0644 ${S}/include/retry_rd_cpx.hpp ${D}${includedir}/bafi/retry_rd_cpx.hpp
        install -D -m 0644 ${S}/include/retry_rd_skx.hpp ${D}${includedir}/bafi/retry_rd_skx.hpp
        install -D -m 0644 ${S}/include/retry_rd_bhs.hpp ${D}${includedir}/bafi/retry_rd_bhs.hpp
        install -D -m 0644 ${S}/include/mca_srf.hpp ${D}${includedir}/bafi/mca_srf.hpp
        install -D -m 0644 ${S}/include/mca_srf_defs.hpp ${D}${includedir}/bafi/mca_srf_defs.hpp
        install -D -m 0644 ${S}/include/tor_srf.hpp ${D}${includedir}/bafi/tor_srf.hpp
}

