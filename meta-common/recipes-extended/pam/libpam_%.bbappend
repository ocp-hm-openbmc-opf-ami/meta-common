FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
            file://pam.d/common-auth \
            file://faillock.conf \
           "

