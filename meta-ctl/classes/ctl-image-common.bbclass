IMAGE_INSTALL:append = " \
                         phosphor-node-manager-proxy \
                         secure-boot-manager \
                       "
IMAGE_CLASSES:append = "image_types image_types_phosphor_auto_secure_boot qemuboot"

DISTRO_FEATURES_EGS = " smbios-no-dimm \
                      "

DISTRO_FEATURES += " ${DISTRO_FEATURES_CTL}"
