FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:remove:ctl-features = " \
    file://telemetry/0001-Added-PmtService-to-Service-Config-Manager.patch"
