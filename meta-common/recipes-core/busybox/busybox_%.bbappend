FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
           file://disable.cfg \
           file://enable.cfg \
           file://CVE-2022-48174.patch \
           file://CVE-2023-42363.patch \
           file://CVE-2023-42366.patch \
		"

SRC_URI += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks','file://dev-only.cfg','',d)}"
