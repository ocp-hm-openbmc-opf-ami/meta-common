FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0001-Update-to-C-20.patch \
    file://0002-Use-variable-for-service-install-location-36.patch \
    file://0003-Support-GCC-13.patch \
    "
