EXTRA_OECMAKE += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', '-DINTEL_PFR_ENABLED=ON', '', d)}"
EXTRA_OECMAKE += "${@bb.utils.contains('IMAGE_FSTYPES', 'intel-secboot', '-DINTEL_PFR_ENABLED=ON', '', d)}"
EXTRA_OECMAKE += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'validation-unsecure', '-DBMC_VALIDATION_UNSECURE_FEATURE=ON', '', d)}"
EXTRA_OECMAKE += "-DUSING_ENTITY_MANAGER_DECORATORS=OFF"

# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/intel-ipmi-oem.git;branch=master;protocol=https"
SRCREV = "b37abfb27f14c05f8cb366c5e382fe66595dd5bf"

inherit pkgconfig
FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

SRC_URI += " \
        file://0007-Adding-the-ACPI-agent-support-to-Mdrv2-OEM-commands.patch \
        file://0008-Skip-finding-tinyxml.patch \
        "
