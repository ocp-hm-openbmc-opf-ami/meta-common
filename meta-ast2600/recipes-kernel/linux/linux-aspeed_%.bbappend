COMPATIBLE_MACHINE = "intel-ast2600"
FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

SRC_URI:append:evb-ast2600 = " file://ast2600evb.config \
                               file://0001-updated-aspeed-ast2600-evb.patch \
                             "
