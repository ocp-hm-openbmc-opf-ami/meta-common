DESCRIPTION = "OpenBMC mtd-util"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

SRC_URI = "git://git@github.com/intel-bmc/firmware.bmc.openbmc.applications.mtd-util.git;protocol=ssh;branch=main"

PV = "1.0+git${SRCPV}"
SRCREV = "ec55c91f04224385163ec4fca3fbf3e77a8be652"


S = "${WORKDIR}/git"

DEPENDS += "dbus systemd sdbusplus openssl zlib boost microsoft-gsl i2c-tools libgpiod"

inherit cmake pkgconfig

# Specify any options you want to pass to cmake using EXTRA_OECMAKE:
EXTRA_OECMAKE = ""

EXTRA_OECMAKE += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', '-DDEVELOPER_OPTIONS=ON', '', d)}"
