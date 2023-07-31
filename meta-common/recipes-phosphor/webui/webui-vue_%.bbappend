# Enable downstream autobump
# # The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = "git://github.com/openbmc/webui-vue.git;branch=master;protocol=https"
SRCREV = "2dabfc1bb488f84ec00f19a51aba144b7f71e45d"

FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"
SRC_URI += " \
    file://login-company-logo.svg \
    file://logo-header.svg \
    file://0001-Change-loading-event-logs.patch \
    "

do_compile:prepend() {
  cp -vf ${S}/.env.intel ${S}/.env
  cp -vf ${WORKDIR}/login-company-logo.svg ${S}/src/assets/images
  cp -vf ${WORKDIR}/logo-header.svg ${S}/src/assets/images
}
