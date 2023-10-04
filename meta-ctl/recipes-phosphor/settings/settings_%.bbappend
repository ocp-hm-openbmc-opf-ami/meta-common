FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

SRC_URI:append += " \
    file://0001-ctl-is-non-PFR-platform-so-PFR-CPLD-not-supported.patch \
    "
