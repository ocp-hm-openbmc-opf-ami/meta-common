inherit python3native
DEPENDS += " python3-requests-native python3-urllib3-native external-signing-utility-native"

FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

SRC_URI:append = " \
           file://pfr_manifest.json \
           file://pfm_manifest.json \
           file://pfm_config.xml \
           file://bmc_config.xml \
           file://bmc_config_spl.xml \
           file://otp_config.xml \
           file://bmc_config_secure.xml \
           file://bmc_config_secure_spl.xml \
           file://pfm_config_secure.xml \
           file://otp_config_secure.xml \
          "

install_secure_config() {
        install -m 400 ${WORKDIR}/pfm_config_secure.xml ${D}/${datadir}/pfrconfig/pfm_config.xml
        install -m 400 ${WORKDIR}/bmc_config_secure.xml ${D}/${datadir}/pfrconfig/bmc_config.xml
        install -m 400 ${WORKDIR}/bmc_config_secure_spl.xml ${D}/${datadir}/pfrconfig/bmc_config_spl.xml
        install -m 400 ${WORKDIR}/otp_config_secure.xml ${D}/${datadir}/pfrconfig/otp_config.xml

        # Note: Key name is taken from external image signing server
        external-signing-utility pub_key "Catlow BMC Code Signing Key Sep 2022" \
                "BMC Code Signing Key Sep 2022" \
                "${D}/${datadir}/pfrconfig/csk_pub.pem"
        external-signing-utility pub_key "Catlow Platform Root Key Sep 2022" \
                "Catlow Platform Root Key Sep 2022" \
                "${D}/${datadir}/pfrconfig/rk_pub.pem"
        external-signing-utility cert "Catlow Platform Root Key Sep 2022" \
                "${D}/${datadir}/pfrconfig/rk_cert.pem"
}

install_debug_config() {
        install -m 400 ${WORKDIR}/pfm_config.xml ${D}/${datadir}/pfrconfig/pfm_config.xml
        install -m 400 ${WORKDIR}/bmc_config.xml ${D}/${datadir}/pfrconfig/bmc_config.xml
        install -m 400 ${WORKDIR}/otp_config.xml ${D}/${datadir}/pfrconfig/otp_config.xml
        install -m 400 ${WORKDIR}/bmc_config_spl.xml ${D}/${datadir}/pfrconfig/bmc_config_spl.xml

        # Note: Key name is taken from Intel PAM server
        external-signing-utility debug get_key "openbmc_pfr_csk_pub_debug_key_Nov_2022" \
                "${D}/${datadir}/pfrconfig/csk_pub.pem"
        external-signing-utility debug get_key "openbmc_pfr_rk_pub_debug_key_Nov_2022" \
                "${D}/${datadir}/pfrconfig/rk_pub.pem"
        external-signing-utility debug get_key "openbmc_pfr_rk_cert_debug_key_Nov_2022" \
                "${D}/${datadir}/pfrconfig/rk_cert.pem"
}

do_install:append () {
        install -m 400 ${WORKDIR}/pfr_manifest.json ${D}/${datadir}/pfrconfig
        install -m 400 ${WORKDIR}/pfm_manifest.json ${D}/${datadir}/pfrconfig
        ${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'secure-keys', 'install_secure_config', 'install_debug_config', d)}
}
