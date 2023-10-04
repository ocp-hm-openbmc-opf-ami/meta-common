SUMMARY = "Node Manager"
DESCRIPTION = "Node Manager"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-NM;md5=ca52b323cca9072ccd0b842f1a668258"

FILESEXTRAPATHS:prepend := "${THISDIR}:"

SRC_URI = "git://git@github.com/intel-bmc/firmware.bmc.openbmc.applications.node-manager.git;protocol=ssh;branch=bhs"
SRC_URI:oks-features = "git://git@github.com/intel-bmc/firmware.bmc.openbmc.applications.node-manager.git;protocol=ssh;branch=main"

SRC_URI += "file://nm_events/logrotate.conf \
            file://nm_events/rsyslog.conf"

SRC_URI:append = " \
           file://0001-Disable-Node-Manager-when-Partition-Boot-is-enabled.patch \
"

# Modify these as desired
PV = "1.0+git${SRCPV}"
SRCREV = "1b6a107f060e7cde36094772ff8111042a8cba8d"
SRCREV:oks-features = "f5573523200916345c17e7cbe54447a2051ea3e9"

S = "${WORKDIR}/git"

SYSTEMD_SERVICE:${PN} += "xyz.openbmc_project.NodeManager.service"

DEPENDS = "boost \
    libpeci \
    nlohmann-json \
    systemd \
    sdbusplus \
    phosphor-logging \
    phosphor-ipmi-host \
    libgpiod \
    "

RDEPENDS:${PN} += "rsyslog"

inherit cmake systemd pkgconfig obmc-phosphor-ipmiprovider-symlink

EXTRA_OECMAKE += "-DYOCTO_DEPENDENCIES=ON"

FULL_OPTIMIZATION = "-Os -pipe -flto -fno-rtti"

HOSTIPMI_PROVIDER_LIBRARY += "libzintelnmipmicmds.so"
NETIPMI_PROVIDER_LIBRARY += "libzintelnmipmicmds.so"

FILES:${PN}:append = " ${libdir}/ipmid-providers/lib*${SOLIBS}"
FILES:${PN}:append = " ${libdir}/host-ipmid/lib*${SOLIBS}"
FILES:${PN}:append = " ${libdir}/net-ipmid/lib*${SOLIBS}"
FILES:${PN}-dev:append = " ${libdir}/ipmid-providers/lib*${SOLIBSDEV}"

do_install:append() {
    install -m 644 -D ${WORKDIR}/nm_events/logrotate.conf ${D}${sysconfdir}/logrotate.d/nm_events.rsyslog
    install -m 644 -D ${WORKDIR}/nm_events/rsyslog.conf ${D}${sysconfdir}/rsyslog.d/nm_events.conf
}
