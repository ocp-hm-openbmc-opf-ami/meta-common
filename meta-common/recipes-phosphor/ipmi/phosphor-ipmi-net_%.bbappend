inherit useradd

USERADD_PACKAGES = "${PN}"
# add a group called ipmi
GROUPADD_PARAM:${PN} = "ipmi "

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Enable downstream autobump to fix sync build, can be removed later
# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI += "git://github.com/openbmc/phosphor-net-ipmid;branch=master;protocol=https"
SRCREV = "099fb097d1671bc057a0b149de58b8b66c14e9a2"

SRC_URI += " file://10-nice-rules.conf \
             file://0006-Modify-dbus-namespace-of-chassis-control-for-guid.patch \
             file://0012-rakp12-Add-username-to-SessionInfo-interface.patch \
           "

do_install:append() {
    mkdir -p ${D}${sysconfdir}/systemd/system/phosphor-ipmi-net@.service.d/
    install -m 0644 ${WORKDIR}/10-nice-rules.conf ${D}${sysconfdir}/systemd/system/phosphor-ipmi-net@.service.d/
}
