
SUMMARY = "Beep code manager service"
DESCRIPTION = "The beep code manager service will provide a method for beep code"

SRC_URI = "\
    file://CMakeLists.txt;subdir=${BP} \
    file://beepcode_mgr.cpp;subdir=${BP} \
    "
PV = "0.1"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

SYSTEMD_SERVICE:${PN} = "beepcode-mgr.service"

inherit cmake pkgconfig
inherit obmc-phosphor-systemd

DEPENDS += " \
            sdbusplus \
            phosphor-logging \
            boost \
           "
