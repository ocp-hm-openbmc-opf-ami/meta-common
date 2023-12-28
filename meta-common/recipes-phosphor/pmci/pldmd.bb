SUMMARY = "PLDM Requester Stack"
DESCRIPTION = "Implementation of PLDM specifications"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI += "git://git@github.com/intel-bmc/firmware.bmc.openbmc.applications.pldmd.git;protocol=ssh;branch=main"
SRCREV = "20d916c06a3afa954f8f0e453c0e43ce7742a5ad"

S = "${WORKDIR}/git"

PV = "1.0+git${SRCPV}"

inherit cmake pkgconfig systemd

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS += " \
    libpldm-intel \
    mctp-wrapper \
    systemd \
    sdbusplus \
    phosphor-logging \
    gtest \
    boost \
    phosphor-dbus-interfaces \
    mctpwplus \
    "

FILES:${PN} += "${systemd_system_unitdir}/xyz.openbmc_project.pldmd.service"
SYSTEMD_SERVICE:${PN} += "xyz.openbmc_project.pldmd.service"
