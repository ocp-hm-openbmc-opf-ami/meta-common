FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

SRC_URI += " \
    file://0001-Suppress-deprecation-warnings-for-OpenSSL-3.0.patch \
    "
