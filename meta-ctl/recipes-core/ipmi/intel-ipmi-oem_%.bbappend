FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

SRC_URI:remove:ctl-features = " \
    file://0002-Added-bit-for-Pmt-Service-configuration.patch \
    "

SRC_URI += " \
    file://0001-OOB-Bios-config-not-POR-for-ctl-hence-removing-it.patch \
    "
