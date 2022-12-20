inherit obmc-phosphor-full-fitimage

#
# Emit the fitImage ITS OPTEE section
#
# $1 ... .its filename
# $2 ... Image counter
# $3 ... Path to OPTEE image
# $4 ... Hash type
#
# TO-BE-FIXED: remove hard coded load address and entry
#
fitimage_emit_section_optee() {

    optee_csum="${4}"
    if [ -n "${optee_csum}" ]; then
        hash_blk=$(cat << EOF
                        hash-1 {
                                algo = "${optee_csum}";
                        };
EOF
        )
    fi

    cat << EOF >> ${1}
                optee-${2} {
                        description = "OPTEE os";
                        data = /incbin/("${3}");
                        type = "kernel";
                        arch = "${UBOOT_ARCH}";
                        os = "linux";
                        compression = "none";
                        load = <0x9affffe4>;
                        entry = <0x9b000000>;
                        ${hash_blk}
                };
EOF
}

#
# Emit the fitImage ITS configuration section
#
# $1 ... .its filename
# $2 ... Linux kernel ID
# $3 ... DTB image name
# $4 ... ramdisk ID
# $5 ... optee os ID
# $6 ... config ID
# $7 ... default flag
# $8 ... Hash type
# $9 ... DTB index
fitimage_emit_section_config_optee() {

    conf_csum="${8}"
    if [ -n "${conf_csum}" ]; then
        hash_blk=$(cat << EOF
                        hash-1 {
                                algo = "${conf_csum}";
                        };
EOF
        )
    fi
    if [ -n "${UBOOT_SIGN_ENABLE}" ] ; then
        conf_sign_keyname="${UBOOT_SIGN_KEYNAME}"
    fi

    # Test if we have any DTBs at all
    conf_desc="Linux kernel"
    kernel_line="kernel = \"kernel-${2}\";"
    fdt_line=""
    ramdisk_line=""
    setup_line=""
    default_line=""
    conf_desc_optee=""
    optee_line=""
    loadable_line=""

    if [ -n "${3}" ]; then
        conf_desc="${conf_desc}, FDT blob"
        fdt_line="fdt = \"fdt-${3}\";"
    fi

    if [ -n "${4}" ]; then
        conf_desc="${conf_desc}, ramdisk"
        ramdisk_line="ramdisk = \"ramdisk-${4}\";"
    fi

    if [ -n "${5}" ]; then
        conf_desc_optee="Optee"
        optee_line="kernel = \"optee-${2}\";"
        loadable_line="loadables = \"kernel-${5}\";"
    fi

    if [ -n "${6}" ]; then
        conf_desc="${conf_desc}, setup"
        setup_line="setup = \"setup-${5}\";"
    fi

    if [ "${7}" = "1" ]; then
        default_line="default = \"conf-optee-${3}\";"
    fi

    cat << EOF >> ${1}
                ${default_line}
                conf-${3} {
                        description = "${7} ${conf_desc}";
                        ${kernel_line}
                        ${fdt_line}
                        ${ramdisk_line}
                        ${setup_line}
                        ${hash_blk}
                };
                conf-optee-${3} {
                        description = "${7} ${conf_desc_optee} ${conf_desc}";
                        ${optee_line}
                        ${fdt_line}
                        ${ramdisk_line}
                        ${loadable_line}
                        ${setup_line}
                        ${hash_blk}
EOF

    if [ ! -z "${conf_sign_keyname}" ] ; then

        sign_line="sign-images = \"kernel\""

        if [ -n "${3}" ]; then
            sign_line="${sign_line}, \"fdt\""
        fi

        if [ -n "${4}" ]; then
            sign_line="${sign_line}, \"ramdisk\""
        fi

        if [ -n "${5}" ]; then
            sign_line="${sign_line}, \"optee\""
        fi

        if [ -n "${6}" ]; then
            sign_line="${sign_line}, \"setup\""
        fi

        sign_line="${sign_line};"

        cat << EOF >> ${1}
                        signature-1 {
                                algo = "${conf_csum},rsa2048";
                                key-name-hint = "${conf_sign_keyname}";
                                ${sign_line}
                        };
EOF
    fi

    cat << EOF >> ${1}
                };
EOF
}

#
# Assemble fitImage
#
# $1 ... .its filename
# $2 ... fitImage name
# $3 ... include rootfs
fitimage_assemble_optee() {
    kernelcount=1
    dtbcount=""
    DTBS=""
    ramdiskcount=${3}
    opteecount=""
    setupcount=""
    #hash_type="sha256"
    hash_type=""
    rm -f ${1} ${2}

    #
    # Step 0: find the kernel image in the deploy/images/$machine dir
    #
    KIMG=""
    for KTYPE in zImage bzImage vmlinuz; do
        if [ -e "${DEPLOY_DIR_IMAGE}/${ktype}" ]; then
            KIMG="${DEPLOY_DIR_IMAGE}/${KTYPE}"
            break
        fi
    done
    if [ -z "${KIMG}" ]; then
        bbdebug 1 "Failed to find kernel image to pack into full fitimage"
        return 1
    fi

    fitimage_emit_fit_header ${1}

    #
    # Step 1: Prepare a kernel image section.
    #
    fitimage_emit_section_maint ${1} imagestart

    fitimage_emit_section_kernel ${1} "${kernelcount}" "${KIMG}" "none" "${hash_type}"

    #
    # Step 2: Prepare a DTB image section
    #
    if [ -n "${KERNEL_DEVICETREE}" ]; then
        dtbcount=1
        for DTB in ${KERNEL_DEVICETREE}; do
            if echo ${DTB} | grep -q '/dts/'; then
                bberror "${DTB} contains the full path to the the dts file, but only the dtb name should be used."
                DTB=`basename ${DTB} | sed 's,\.dts$,.dtb,g'`
            fi
            DTB_PATH="${DEPLOY_DIR_IMAGE}/${DTB}"
            if [ ! -e "${DTB_PATH}" ]; then
                bbwarn "${DTB_PATH} does not exist"
                continue
            fi

            DTB=$(echo "${DTB}" | tr '/' '_')
            DTBS="${DTBS} ${DTB}"
            fitimage_emit_section_dtb ${1} ${DTB} ${DTB_PATH} "${hash_type}"
        done
    fi

    #
    # Step 3: Prepare a setup section. (For x86)
    #
    if [ -e arch/${ARCH}/boot/setup.bin ]; then
        setupcount=1
        fitimage_emit_section_setup ${1} "${setupcount}" arch/${ARCH}/boot/setup.bin "${hash_type}"
    fi

    #
    # Step 4: Prepare a ramdisk section.
    #
    if [ "x${ramdiskcount}" = "x1" ] ; then
        bbdebug 1 "searching for requested rootfs"
        # Find and use the first initramfs image archive type we find
        for img in squashfs-lz4 squashfs-xz squashfs cpio.lz4 cpio.lzo cpio.lzma cpio.xz cpio.gz cpio; do
            initramfs_path="${DEPLOY_DIR_IMAGE}/${IMAGE_BASENAME}-${MACHINE}.${img}"
            bbdebug 1 "looking for ${initramfs_path}"
            if [ -e "${initramfs_path}" ]; then
                bbdebug 1 "Found ${initramfs_path}"
                fitimage_emit_section_ramdisk ${1} "${ramdiskcount}" "${initramfs_path}" "${hash_type}"
                break
            fi
        done
    fi

    #
    # Step 5: Prepare an optee os section.
    #
    bbdebug 1 "searching for requested optee"
    # Find and use the first optee os we find
    optee_path="${DEPLOY_DIR_IMAGE}/optee/tee.bin"
    if [ -e "${optee_path}" ]; then
        bbdebug 1 "Found ${optee_path}"
        opteecount=1
        fitimage_emit_section_optee ${1} "${opteecount}" "${optee_path}" "${hash_type}"
    else
        bbdebug 1 "Did not find ${optee_path}"
    fi

    fitimage_emit_section_maint ${1} sectend

    # Force the first Kernel and DTB in the default config
    kernelcount=1
    if [ -n "${dtbcount}" ]; then
        dtbcount=1
    fi

    #
    # Step 5: Prepare a configurations section
    #
    fitimage_emit_section_maint ${1} confstart

    if [ -n "${DTBS}" ]; then
        i=1
        for DTB in ${DTBS}; do
            fitimage_emit_section_config_optee ${1} "${kernelcount}" "${DTB}" "${ramdiskcount}" "${opteecount}" "${setupcount}" "`expr ${i} = ${dtbcount}`" "${hash_type}" "${i}"
            i=`expr ${i} + 1`
        done
    fi

    fitimage_emit_section_maint ${1} sectend

    fitimage_emit_section_maint ${1} fitend

    #
    # Step 6: Assemble the image
    #
    uboot-mkimage \
        ${@'-D "${UBOOT_MKIMAGE_DTCOPTS}"' if len('${UBOOT_MKIMAGE_DTCOPTS}') else ''} \
        -f ${1} ${2}

    #
    # Step 7: Sign the image and add public key to U-Boot dtb
    #
    if [ "x${UBOOT_SIGN_ENABLE}" = "x1" ] ; then
        uboot-mkimage \
            ${@'-D "${UBOOT_MKIMAGE_DTCOPTS}"' if len('${UBOOT_MKIMAGE_DTCOPTS}') else ''} \
            -F -k "${UBOOT_SIGN_KEYDIR}" \
            -K "${DEPLOY_DIR_IMAGE}/${UBOOT_DTB_BINARY}" \
            -r ${2}
    fi
}

do_image_fitimage_rootfs_optee() {
    bbdebug 1 "check for rootfs phosphor fitimage"
    cd ${B}
    bbdebug 1 "building rootfs phosphor fitimage"
    fitimage_assemble_optee fitImage-rootfs-${MACHINE}-${DATETIME}.its \
        fitImage-rootfs-${MACHINE}-${DATETIME}.bin 1

    for SFX in its bin; do
        SRC="fitImage-rootfs-${MACHINE}-${DATETIME}.${SFX}"
        SYM="fitImage-rootfs-${MACHINE}.${SFX}"
        if [ -e "${B}/${SRC}" ]; then
            install -m 0644 "${B}/${SRC}" "${DEPLOY_DIR_IMAGE}/${SRC}"
            ln -sf "${SRC}" "${DEPLOY_DIR_IMAGE}/${SYM}"
        fi
    done
    ln -sf "${DEPLOY_DIR_IMAGE}/fitImage-rootfs-${MACHINE}.bin" "image-runtime"
    # build a tarball with the right parts: MANIFEST, signatures, etc.
    # create a directory for the tarball
    mkdir -p "${B}/img"
    cd "${B}/img"
    # add symlinks for the contents
    ln -sf "${DEPLOY_DIR_IMAGE}/u-boot.${UBOOT_SUFFIX}" "image-u-boot"
    ln -sf "${DEPLOY_DIR_IMAGE}/fitImage-rootfs-${MACHINE}.bin" "image-runtime"
    # add the manifest
    bbdebug 1 "Manifest file: ${B}/MANIFEST"
    ln -sf ${B}/MANIFEST .
    # touch the required files to minimize change
    touch image-kernel image-rofs image-rwfs

    tar -h -cvf "${DEPLOY_DIR_IMAGE}/${PN}-image-update-${MACHINE}-${DATETIME}.tar" MANIFEST image-u-boot image-runtime image-kernel image-rofs image-rwfs
    # make a symlink
    ln -sf "${PN}-image-update-${MACHINE}-${DATETIME}.tar" "${DEPLOY_DIR_IMAGE}/image-update-${MACHINE}"
    ln -sf "${PN}-image-update-${MACHINE}-${DATETIME}.tar" "${DEPLOY_DIR_IMAGE}/OBMC-${@ do_get_version(d)}-oob.bin"
    ln -sf "image-update-${MACHINE}" "${DEPLOY_DIR_IMAGE}/image-update"
    ln -sf "image-update-${MACHINE}" "${DEPLOY_DIR_IMAGE}/OBMC-${@ do_get_version(d)}-inband.bin"
}

do_image_fitimage_rootfs_optee[vardepsexclude] = "DATETIME"
do_image_fitimage_rootfs_optee[depends] += " ${DEPS}"

deltask do_image_fitimage_rootfs
addtask do_image_fitimage_rootfs_optee before do_generate_auto after do_image_complete
addtask do_generate_phosphor_manifest before do_image_fitimage_rootfs_optee after do_image_complete
addtask do_generate_release_metainfo before do_generate_phosphor_manifest after do_image_complete
