FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

SRC_URI:append: = " \
    file://0001-CTL-fan-changes-to-adapt-kernel-downgrade.patch \
    "
