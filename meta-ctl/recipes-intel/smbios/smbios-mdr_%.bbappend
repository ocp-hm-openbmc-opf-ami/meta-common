FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0001-Add-Crashlog-collection-support.patch \
    file://0004-CPU-and-PCH-crashlog-collection-over-eSPI-OOB.patch \
    file://0005-Add-support-for-uncore-and-core-crashlog.patch \
    file://0006-CTL-Updating-BMC-to-support-BIOS-version-3.4.patch \
    file://0007-Add-support-to-Clear-Crashlog.patch \
    "

DEPENDS += " boost libespi"
