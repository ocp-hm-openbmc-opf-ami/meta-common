# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/bmcweb.git;branch=master;protocol=https"
SRCREV = "2c9efc3cb140e5c1d4d57b73f0a511880ac7a11f"

DEPENDS += "boost-url"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"


SRC_URI += " \
            file://0001-Firmware-update-configuration-changes.patch \
            file://0002-Use-chip-id-based-UUID-for-Service-Root.patch \
            file://0010-managers-add-attributes-for-Manager.CommandShell.patch \
            file://0011-bmcweb-Add-PhysicalContext-to-Thermal-resources.patch \
            file://0012-Log-RedFish-event-for-Invalid-login-attempt.patch \
            file://0013-Add-UART-routing-logic-into-host-console-connection-.patch \
            file://0014-recommended-fixes-by-crypto-review-team.patch \
            file://0015-Add-state-sensor-messages-to-the-registry.patch \
            file://0016-Fix-bmcweb-crashes-if-socket-directory-not-present.patch \
            file://0018-bmcweb-Add-BMC-Time-update-log-to-the-registry.patch \
            file://0020-Redfish-Deny-set-AccountLockDuration-to-zero.patch \
            file://0023-Add-get-IPMI-session-id-s-to-Redfish.patch \
            file://0024-Add-count-sensor-type.patch \
            file://0026-Revert-Delete-the-copy-constructor-on-the-Request.patch \
            file://0029-Added-support-for-patching-sensors-under-Chassis-Sen.patch \
            file://0030-Add-validation-of-Content-type-header.patch \
            file://0031-Added-seperate-variable-for-mtls-session.patch \
            file://0032-systems-Add-pfr-and-cpld-postcode.patch \
            file://0033-mtls-removed-checking-cookie.patch \
            file://0034-Add-Model-to-ProcessorSummary.patch \
"

# OOB Bios Config:
SRC_URI += " \
            file://biosconfig/0001-Define-Redfish-interface-Registries-Bios.patch \
            file://biosconfig/0002-BaseBiosTable-Add-support-for-PATCH-operation.patch \
            file://biosconfig/0003-Add-support-to-ResetBios-action.patch \
            file://biosconfig/0004-Add-support-to-ChangePassword-action.patch \
            file://biosconfig/0005-Fix-remove-bios-user-pwd-change-option-via-Redfish.patch \
            file://biosconfig/0006-Add-fix-for-broken-feature-Pending-Attributes.patch \
            file://biosconfig/0007-Add-BiosAttributeRegistry-node-under-Registries.patch \
"

# Virtual Media: Backend code is not upstreamed so downstream only patches.
SRC_URI += " \
            file://vm/0001-Revert-Disable-nbd-proxy-from-the-build.patch \
            file://vm/0002-Squashed-reworked-commits.patch \
            file://vm/0003-Add-handlers-for-patch-put-delete.patch \
            file://vm/0004-Apply-async-dbus-API.patch \
            file://vm/0005-Restore-AsyncResp-in-openhandler.patch \
"

# EventService: Temporary pulled to downstream. See eventservice\README for details
SRC_URI += " \
            file://eventservice/0001-Conditional-verify-certificate-check-in-HttpClient.patch \
            file://eventservice/0002-Add-Server-Sent-Event-support.patch \
            file://eventservice/0003-Add-SSE-style-subscription-support-to-eventservice.patch \
            file://eventservice/0004-Log-Redfish-Events-for-all-subscription-actions.patch \
            file://eventservice/0005-Input-parameter-validation-for-Event-Subscription.patch \
            file://eventservice/0006-Delete-Terminated-Event-Subscription.patch \
            file://eventservice/0007-Add-Configure-Self-support-for-Event-Subscriptions.patch \
"


# Temporary downstream mirror of upstream patches, see telemetry\README for details
SRC_URI += " file://telemetry/0001-Revert-Remove-LogService-from-TelemetryService.patch \
             file://telemetry/0002-Switched-bmcweb-to-use-new-telemetry-service-API.patch \
             file://telemetry/0003-Add-Links-Triggers-to-MetricReportDefinition.patch \
             file://telemetry/0004-Add-PUT-and-PATCH-for-MetricReportDefinition.patch \
             file://telemetry/0005-Add-support-for-POST-on-TriggersCollection.patch \
             file://telemetry/0006-Improved-telemetry-service-error-handling.patch \
             file://telemetry/0007-temporary-fix-for-dbus-method-name.patch \
"


# Temporary downstream patch for routing and privilege changes
SRC_URI += "file://http_routing/0001-Add-asyncResp-support-to-handleUpgrade.patch \
            file://http_routing/0002-Move-privileges-to-separate-entity.patch \
            file://http_routing/0003-Add-Support-for-privilege-check-in-handleUpgrade.patch \
            file://http_routing/0004-Add-Privileges-to-Websockets.patch \
            file://http_routing/0005-Add-Privileges-to-SseSockets.patch \
"

# ACPI LogService
SRC_URI += " \
            file://acpi_logservice/0001-Adding-acpi-LogService.patch \
"

# Enable PFR support
EXTRA_OEMESON += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', '-Dredfish-provisioning-feature=enabled', '', d)}"

#Enable Secure boot support
EXTRA_OEMESON += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-secboot', '-Dredfish-provisioning-feature=enabled', '', d)}"

# Enable NBD proxy embedded in bmcweb
EXTRA_OEMESON += " -Dvm-nbdproxy=enabled"

# Disable dependency on external nbd-proxy application
EXTRA_OEMESON += " -Dvm-websocket=disabled"
EXTRA_OEMESON += " -Dredfish-host-logger=disabled"

# This will set the max size of image file which can be uploaded
# to bmcweb over https. Curently its set to 64MB for allowing
# IFWI full SPI flash binary.
EXTRA_OEMESON += " -Dhttp-body-limit=64"

RDEPENDS:${PN}:remove = " jsnbd"

do_install:append(){
	install -d ${D}/var/lib/bmcweb
}
