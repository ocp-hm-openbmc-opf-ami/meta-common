SUMMARY = "Special mode manager daemon to handle manufacturing modes"
DESCRIPTION = "Daemon exposes the manufacturing mode property"

PV = "1.0+git${SRCPV}"

S = "${WORKDIR}/git"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

SRC_URI = "git://git@github.com/intel-collab/firmware.bmc.openbmc.applications.special-mode-manager.git;protocol=ssh;branch=main"
SRCREV = "3434f220796f292458cb74be12149025aa0c4a61"

EXTRA_OECMAKE += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'validation-unsecure', '-DBMC_VALIDATION_UNSECURE_FEATURE=ON', '', d)}"

inherit cmake systemd pkgconfig
SYSTEMD_SERVICE:${PN} = "specialmodemgr.service"

DEPENDS += " \
    systemd \
    sdbusplus \
    phosphor-logging \
    boost \
    libpam \
    libgpiod \
    "
RDEPENDS:${PN} += " \
    libsystemd \
    sdbusplus \
    phosphor-logging \
    "
