FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"

SRC_URI:append = " \
          file://ast2600-secure_config_RSA3072_SHA384.cfg \
          file://ast2600-secure_RSA2048_SHA256.cfg \
          file://ast2600-secure_RSA3072_SHA384.cfg \
          "

install_2k_debug_keys() {
    install -m 0644 ${WORKDIR}/ast2600-secure_RSA2048_SHA256.cfg \
        ${D}${datadir}/secureboot-config/ast2600/ast2600-secureboot-config.cfg

    external-signing-utility debug get_key "openbmc_secureboot_debug_rsa_key_public_2048_0" \
        "${KEY_INSTALL_DIR}/rsa_key_public_2048_0.pem"
    external-signing-utility debug get_key "openbmc_secureboot_debug_rsa_key_public_2048_1" \
        "${KEY_INSTALL_DIR}/rsa_key_public_2048_1.pem"
    external-signing-utility debug get_key "openbmc_secureboot_debug_rsa_key_public_2048_2" \
        "${KEY_INSTALL_DIR}/rsa_key_public_2048_2.pem"
    external-signing-utility debug get_key "openbmc_secureboot_debug_rsa_key_public_2048_3" \
        "${KEY_INSTALL_DIR}/rsa_key_public_2048_3.pem"
    external-signing-utility debug get_key "openbmc_secureboot_debug_rsa_key_public_2048_4" \
        "${KEY_INSTALL_DIR}/rsa_key_public_2048_4.pem"

    external-signing-utility debug get_key "openbmc_secureboot_debug_spl_key_crt_2048" \
        "${KEY_INSTALL_DIR}/spl_key_2048.crt"
    external-signing-utility debug get_key "openbmc_secureboot_debug_spl_key_private_2048" \
        "${KEY_INSTALL_DIR}/spl_key_2048.key"
}

install_3k_debug_keys() {
    install -m 0644 ${WORKDIR}/ast2600-secure_RSA3072_SHA384.cfg \
        ${D}${datadir}/secureboot-config/ast2600/ast2600-secureboot-config.cfg

    external-signing-utility debug get_key "openbmc_secureboot_debug_rsa_key_public_3072_0" \
        "${KEY_INSTALL_DIR}/rsa_key_public_3072_0.pem"
    external-signing-utility debug get_key "openbmc_secureboot_debug_rsa_key_public_3072_1" \
        "${KEY_INSTALL_DIR}/rsa_key_public_3072_1.pem"
    external-signing-utility debug get_key "openbmc_secureboot_debug_rsa_key_public_3072_2" \
        "${KEY_INSTALL_DIR}/rsa_key_public_3072_2.pem"
    external-signing-utility debug get_key "openbmc_secureboot_debug_rsa_key_public_3072_3" \
        "${KEY_INSTALL_DIR}/rsa_key_public_3072_3.pem"
    external-signing-utility debug get_key "openbmc_secureboot_debug_rsa_key_public_3072_4" \
        "${KEY_INSTALL_DIR}/rsa_key_public_3072_4.pem"

    external-signing-utility debug get_key "openbmc_secureboot_debug_spl_key_crt_3072" \
        "${KEY_INSTALL_DIR}/spl_key_3072.crt"
    external-signing-utility debug get_key "openbmc_secureboot_debug_spl_key_private_3072" \
        "${KEY_INSTALL_DIR}/spl_key_3072.key"
}

install_debug_config() {
    ${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'RSA2048-keys', 'install_2k_debug_keys', 'install_3k_debug_keys', d)}
}

# TODO: Move this config to meta-ctl layer
install_secure_config() {
    install -m 0644 ${WORKDIR}/ast2600-secure_config_RSA3072_SHA384.cfg \
        ${D}${datadir}/secureboot-config/ast2600/ast2600-secureboot-config.cfg

    #TODO: Read input and output file names from config file
    external-signing-utility \
        pub_key "Catlow RoT Code Signing Key Sep 2022" \
        "Catlow Secure Boot RoT Signing Key 0" \
        "${KEY_INSTALL_DIR}/rsa_key_public_3072_0.pem"
    external-signing-utility \
        pub_key "Catlow RoT Code Signing Key Sep 2022" \
        "Catlow Secure Boot RoT Signing Key 1" \
        "${KEY_INSTALL_DIR}/rsa_key_public_3072_1.pem"
    external-signing-utility \
        pub_key "Catlow RoT Code Signing Key Sep 2022" \
        "Catlow Secure Boot RoT Signing Key 2" \
        "${KEY_INSTALL_DIR}/rsa_key_public_3072_2.pem"
    external-signing-utility \
        pub_key "Catlow RoT Code Signing Key Sep 2022" \
        "Catlow Secure Boot RoT Signing Key 3" \
        "${KEY_INSTALL_DIR}/rsa_key_public_3072_3.pem"
    external-signing-utility \
        pub_key "Catlow RoT Code Signing Key Sep 2022" \
        "Catlow Secure Boot RoT Signing Key 4" \
        "${KEY_INSTALL_DIR}/rsa_key_public_3072_4.pem"
    external-signing-utility \
        cert "Catlow Secure-Boot U-Boot Signing Key Sep 2022" \
        "${KEY_INSTALL_DIR}/spl_key_3072.crt"

}

do_install:append () {
    ${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'secure-keys', 'install_secure_config', 'install_debug_config', d)}
}
