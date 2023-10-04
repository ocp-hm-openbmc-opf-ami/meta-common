FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

SRC_URI:append = " \
    file://CB-Baseboard.json \
    file://CB-Chassis.json \
    "

do_install:append(){
     install -d ${D}/usr/share/entity-manager/configurations
     install -m 0444 ${WORKDIR}/CB-Baseboard.json ${D}/usr/share/entity-manager/configurations
     install -m 0444 ${WORKDIR}/CB-Chassis.json ${D}/usr/share/entity-manager/configurations
}
