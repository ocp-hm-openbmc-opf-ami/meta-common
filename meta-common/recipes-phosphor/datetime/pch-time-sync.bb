
SUMMARY = "PCH BMC time service"
DESCRIPTION = "This service will read date/time from PCH device periodically, and set the BMC system time accordingly"

SRC_URI = "\
    file://CMakeLists.txt;subdir=${BP} \
    file://pch-time-sync.cpp;subdir=${BP} \
    "
PV = "0.1"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

SYSTEMD_SERVICE:${PN} = "pch-time-sync.service"

inherit cmake
inherit obmc-phosphor-systemd

DEPENDS += " \
            sdbusplus \
            phosphor-logging \
            boost \
            i2c-tools \
           "
