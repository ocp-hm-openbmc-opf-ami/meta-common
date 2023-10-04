SUMMARY = "Platform Minitoring Technology"
DESCRIPTION = "PMT is an service which consumes PMT telemetry and integrates service with Redfish API."

SRC_URI = "git://git@github.com/intel-bmc/firmware.bmc.openbmc.applications.platform-monitoring-technology.git;protocol=ssh;branch=main"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Telemetry;md5=858e10cab31872ff374c48e5240d566a"

PV = "1.0+git${SRCPV}"
SRCREV = "25a63941980690ec3b30bf0712a94de5d6cecd0b"

FILES:${PN} += "${datadir}/** "

inherit meson pkgconfig
inherit systemd

RDEPENDS:${PN} += "mctpd \
                   boost \
"

DEPENDS = "sdbusplus \
           boost \
           libmctp-intel \
           libpmt \
           avro-c++ \
           mpfr \
           gmp \
           modern-cpp-kafka \
           nlohmann-json \
"

EXTRA_OEMESON = "--buildtype=minsize -Dtests=disabled -Dyocto-deps=enabled"

S = "${WORKDIR}/git"

SYSTEMD_SERVICE:${PN} += "xyz.openbmc_project.Pmt.service"

do_install:append() {
        # Systemd service:
        install -d ${D}${systemd_system_unitdir}
        install -m 0644 ${S}/xyz.openbmc_project.Pmt.service ${D}${systemd_system_unitdir}

        # Aggregators configuration, should be updated after moving avro file to artifactory:
        install -d ${D}/var/pmt/aggregators
        install -m 0644 ${S}/aggregators/gnr_oobcore.avro ${D}/var/pmt/aggregators/
        install -m 0644 ${S}/aggregators/gnr_punitcdie.avro ${D}/var/pmt/aggregators/
}
