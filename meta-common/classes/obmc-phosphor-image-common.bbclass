inherit obmc-phosphor-image
inherit license_static

IMAGE_FEATURES += " \
        obmc-bmc-state-mgmt \
        obmc-bmcweb \
        obmc-chassis-mgmt \
        obmc-chassis-state-mgmt \
        obmc-devtools \
        obmc-fan-control \
        obmc-fan-mgmt \
        obmc-flash-mgmt \
        obmc-host-ctl \
        obmc-host-ipmi \
        obmc-host-state-mgmt \
        obmc-inventory \
        obmc-leds \
        obmc-logging-mgmt \
        obmc-remote-logging-mgmt \
        obmc-net-ipmi \
        obmc-sensors \
        obmc-software \
        obmc-system-mgmt \
        obmc-user-mgmt \
        ${@bb.utils.contains('DISTRO_FEATURES', 'obmc-ubi-fs', 'read-only-rootfs', '', d)} \
        ${@bb.utils.contains('DISTRO_FEATURES', 'phosphor-mmc', 'read-only-rootfs', '', d)} \
        ssh-server-dropbear \
        obmc-debug-collector \
        obmc-network-mgmt \
        obmc-settings-mgmt \
        obmc-console \
        "

IMAGE_INSTALL:append = " \
        dbus-broker \
        entity-manager \
        fru-device \
        ipmitool \
        intel-ipmi-oem \
        phosphor-ipmi-ipmb \
        dbus-sensors \
        phosphor-pid-control \
        phosphor-host-postd \
        phosphor-certificate-manager \
        phosphor-sel-logger \
        smbios-mdr \
        obmc-ikvm \
        system-watchdog \
        srvcfg-manager \
        callback-manager \
        phosphor-post-code-manager \
        preinit-mounts \
        mtd-utils-ubifs \
        special-mode-mgr \
        rsyslog \
        phosphor-u-boot-mgr \
        prov-mode-mgr \
        ac-boot-check \
        host-error-monitor \
        psu-manager \
        kernel-panic-check \
        hsbp-manager \
        security-registers-check \
        nv-sync \
        security-manager \
        virtual-media \
        host-misc-comm-manager \
        biosconfig-manager \
        telemetry \
        i3c-tools \
        zip \
        peci-pcie \
        libespi \
        mctpd \
        pldmd \
        pmci-launcher \
        nvmemi-daemon \
        "

IMAGE_INSTALL:append:bhs-features = " \
        power-feature-discovery \
        "

IMAGE_INSTALL:append = " ${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'pfr-manager', '', d)}"

IMAGE_INSTALL:append = " ${@bb.utils.contains('IMAGE_FSTYPES', 'intel-pfr', 'ncsi-monitor', '', d)}"
IMAGE_INSTALL:append = " ${@bb.utils.contains('IMAGE_FSTYPES', 'intel-secboot', 'ncsi-monitor', '', d)}"

IMAGE_INSTALL:append = "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', ' mctp-emulator ', '', d)}"

# this package was flagged as a security risk
IMAGE_INSTALL:remove = " lrzsz"

BAD_RECOMMENDATIONS += "phosphor-settings-manager"
