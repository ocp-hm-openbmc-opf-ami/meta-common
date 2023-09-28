# Enable downstream autobump - this can be removed after upstream sync
# The URI is required for the autobump script but keep it commented
# to not override the upstream value
# SRC_URI = # "git://github.com/openbmc/obmc-console;branch=master;protocol=https;nobranch=1"
SRCREV = "dfda5afb4ff7c76c4df3ebebbf496fdbda0fbbae"

FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"
OBMC_CONSOLE_HOST_TTY = "ttyS2"
SRC_URI += "file://sol-configure.sh \
            file://pre-post-routing.conf \
            file://server.ttyS2.conf \
            file://0001-Use-sol-configure.sh-to-configure-UART-routing.patch \
           "

# Enable the socket (with drop-in configuration below) to watch for connections
# to @obmc-console UNIX socket as a trigger to start obmc-console service.
SYSTEMD_SERVICE:${PN} += " \
        ${PN}@${OBMC_CONSOLE_HOST_TTY}.socket \
        "

do_install:append() {
    # Delete UART rules that automatically start services for each TTY
    rm -rf ${D}${base_libdir}/udev/rules.d/80-obmc-console-uart.rules

    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/sol-configure.sh ${D}${bindir}

    local drop_in=${D}${sysconfdir}/systemd/system/${PN}@${OBMC_CONSOLE_HOST_TTY}
    local service_drop_in=${drop_in}.service.d
    local socket_drop_in=${drop_in}.socket.d

    # Install service drop-in override to add UART routing and baud configuration
    install -d $service_drop_in
    install -m 0644 ${WORKDIR}/pre-post-routing.conf $service_drop_in

}
