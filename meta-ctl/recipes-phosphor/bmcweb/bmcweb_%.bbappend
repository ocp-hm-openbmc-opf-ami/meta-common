FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://0001-disable-registering-biosconfigservice-routes.patch \
    file://0002-Add-redfish-events-for-BMC-secure-FW-update.patch \
    file://0003-Fix-for-IFWI-Version-showing-in-Running-Image.patch \
    file://0004-Add-support-for-crashlog-collection-in-Redfish.patch \
    file://0005-Fix-Clear-Crashlog-response.patch \
    file://0006-Fix-Crashlog-collect-task-status.patch \
    file://0007-Add-SendRawPECI-crashlog-API-in-Redfish.patch \
    file://0008-CTL-Disable-dead-URLs-in-Redfish.patch \
    file://0009-Add-redfish-events-BMC-secure-FW-update.patch \
    "
