EXTRA_OECMAKE += "-DCTL=${ctl-features}"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LINUX_VERSION = "5.15.94"
KBRANCH = "dev-5.15-intel"
SRCREV = "ef5fabf0a4625efe77b2c145131f0fedb293755b"


SRC_URI += " \
    file://intel-ctl.cfg \
    file://0011-Modified-image-layout-for-CTL-as-per-secureboot.patch \
    file://0012-CTL-Update-DTS-temp-calculation-from-PCS10-output.patch \
    file://0013-soc-aspeed-spilock-Update-SPI-Lock-unlock-logic.patch \
    file://0014-CTL-Remove-unsupported-power-and-energy-sensors.patch \
    file://0015-Fix-build-with-GCC-13.patch \
    "
