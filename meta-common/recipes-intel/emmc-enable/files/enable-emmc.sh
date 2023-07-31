#!/bin/bash

#
# Enable EMMC storage so that it can be used by BMC
#

deleteAllPartition () {
        (
        echo o # create a new empty DOS partition table
        echo w # write table to disk and exit
        ) | fdisk /dev/mmcblk0 > /dev/null
}

createAllPartitions () {
        # Partition 1 - 512MB
        local -r firstSectorOfPartition1=16
        local -r lastSectorOfPartition1=1048592

        (
        echo n # add a new partition
        echo p # primary partition
        echo 1 # partition number
        echo $firstSectorOfPartition1
        echo $lastSectorOfPartition1
        echo w # write table to disk and exit
        ) | fdisk /dev/mmcblk0 > /dev/null
        sleep 1 
}

printAllPartitionInfo () {
       fdisk -l /dev/mmcblk0 
}

mountPartition () {
	local partIdx=$1
	local mountPath=$2

	# create directory if not exist
	if [ ! -d "$mountPath" ]; then
		mkdir -p $mountPath
	fi

        mkfs.vfat /dev/mmcblk0p$partIdx > /dev/null
        mount /dev/mmcblk0p$partIdx $mountPath > /dev/null
}

get_validation_hook_jumper() {
    if dbg_gpio=$(gpiofind "FM_BMC_VAL_EN"); then
        jum_val=$(gpioget $dbg_gpio);
        if [[ "$jum_val" -eq 1 ]]; then
            return 0
        fi
    fi

    return 1
}

main () {

	# As of now, eMMC is needed only for firmware updatee, that too
	# for large files such as BMC/BIOS full flash. These features
	# are enabled only for validation purpose. So create & mount
	# eMMC partitions only if validation hook jumper is set.
	if ! get_validation_hook_jumper; then
		echo "Validation hook jumper is unset - eMMC support disabled"
		return
	fi

        echo "Enabling the eMMC support..."

        deleteAllPartition

	# As of now, Create single partition for image uploads
        createAllPartitions

	# Mount partition 1 to "/tmp/images"
        mountPartition 1 "/tmp/images/"

	# For debug, lets print all partitions info
        printAllPartitionInfo
}

main

