FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:intel-ast2600 = "file://init"

RDEPENDS:${PN} += "bash"
