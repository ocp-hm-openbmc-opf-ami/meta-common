SUMMARY = "Dimm Sensor"
DESCRIPTION = "Dimm Sensor Executable"

SRC_URI = "\
    file://CMakeLists.txt \
    file://DimmSensor.cpp \
    "

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COREBASE}/openbmc-meta-intel/meta/files/common-licenses/Intel-BMC-Base;md5=f66be55877b5b739110e445efdcf5fbc"

S = "${WORKDIR}"

inherit cmake

# linux-libc-headers guides this way to include custom uapi headers
CXXFLAGS:append = " -I ${STAGING_KERNEL_DIR}/include/uapi"
do_configure[depends] += "virtual/kernel:do_shared_workdir"
