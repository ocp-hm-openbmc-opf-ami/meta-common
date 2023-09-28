FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://CVE-2023-2975.patch \
    file://CVE-2023-3446.patch \
    "
