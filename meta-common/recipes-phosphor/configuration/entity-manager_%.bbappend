# this is here just to bump faster than upstream
# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/entity-manager.git;branch=master;protocol=https"
SRCREV = "aca73883ca6bcee3dde8cbc8cf7d4e51f2959b73"

RDEPENDS:${PN}:intel-ast2600 += " default-fru"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
             file://0001-fru-device-Add-MUX-channel-name-to-FRU-objects.patch \
             file://0002-Entity-manager-Add-support-to-update-assetTag.patch \
             file://0003-Add-logs-to-fwVersionIsSame.patch \
             file://0004-Adding-MUX-and-Drives-present-in-HSBP-in-json-config.patch \
             file://0005-Allow-MUX-idle-state-to-be-configured-as-DISCONNECT.patch \
             file://0006-Change-HSBP-FRU-address-and-add-MUX-mode-configurati.patch \
             file://0007-dynamic-threshold-configuration-for-SOLUM-PSU.patch \
           "

