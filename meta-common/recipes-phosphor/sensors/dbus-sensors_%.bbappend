FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
PROJECT_SRC_DIR := "${THISDIR}/${PN}"

# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/dbus-sensors.git;branch=master;protocol=https"
SRCREV = "63c9122ea5ceaa89016663d259c1eda1705474f3"

SRC_URI += "\
    file://intrusionsensor-depend-on-networkd.conf \
    file://0001-PSUSensor-support-PWM-mode-control-of-PSU-fan.patch \
    file://0002-Fix-PECI-client-creation-flow.patch \
    file://0003-Fix-missing-threshold-de-assert-event-when-threshold.patch \
    file://0004-Fan-Tach-Sensor-Threshold-Ignore-Zero.patch \
    file://0005-Fix-PECI-ioctl-number.patch \
    file://0006-CPUSensor-create-RequiredTempSensor-if-defined.patch \
    "

DEPENDS:append = " libgpiod libmctp systemd"

PACKAGECONFIG += " \
    adcsensor \
    exitairtempsensor \
    fansensor \
    hwmontempsensor \
    intelcpusensor \
    intrusionsensor \
    ipmbsensor \
    mcutempsensor \
    psusensor \
"

# Enable Validation unsecure based on IMAGE_FEATURES
EXTRA_OEMESON += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'validation-unsecure', '-Dvalidate-unsecure-feature=enabled', '', d)}"

do_install:append() {
    svc="xyz.openbmc_project.intrusionsensor.service"
    srcf="${WORKDIR}/intrusionsensor-depend-on-networkd.conf"
    dstf="${D}/etc/systemd/system/${svc}.d/10-depend-on-networkd.conf"
    mkdir -p "${D}/etc/systemd/system/${svc}.d"
    install "${srcf}" "${dstf}"
}
