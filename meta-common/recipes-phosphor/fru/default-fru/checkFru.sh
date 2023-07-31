#!/bin/bash

# this script checks the gpio id and loads the correct baseboard fru
FRU_PATH="/etc/fru"
PROD_ID_PATH="/var/cache/private"
FRU_FILE="$FRU_PATH/baseboard.fru.bin"
PROD_ID_FILE="$PROD_ID_PATH/prodID"
PARTITION_BOOT_FLAG_FILE="$PROD_ID_PATH/PartitionBootFlag"
R1S_PRESENT_FLAG="$PROD_ID_PATH/R1SPresentFlag"
SYSTEM_JSON_FILE="/var/configuration/system.json"

# Default implementation (overrideable)
get_sku_signal_name() {
    local index="$1"
    echo "FM_BMC_BOARD_SKU_ID${index}_N"
}

# Default implementation (overrideable)
is_partition_boot() {
    false
}

# Default implementation (overrideable)
is_r1s_present() {
    false
}

# Default implementation (overrideable)
is_board_eeprom_programmed() {
    false
}

# Pull in platform specialized implementations
source decodeBoardID.sh

read_id() {
    local idx=0
    local result=0
    local value=0
    for ((idx=0; idx<6; idx++))
    do
        # shellcheck disable=SC2046,SC2155
        typeset -i value=$(gpioget $(gpiofind "$(get_sku_signal_name $idx)"))
        value=$((value << idx))
        result=$((result | value))
    done
    echo $result
}

restore_config() {
    # Restore configuration by writing a flag to persistent file. Actual work is
    # done in init script on next boot.
    local RESTORE_CONFIG_FILE="/tmp/.rwfs/.restore_op"
    local FULL_RESTORE=2
    local retry_n=10
    while ((retry_n > 0))
    do
        if echo $FULL_RESTORE > $RESTORE_CONFIG_FILE
        then
            sync
            reboot -f
        fi
        sleep 1
        ((retry_n--))
    done
    return 1
}

board_id=$(read_id)
readarray -t board_details <<< $(decode_board_id "$board_id")
name=${board_details[0]:-Unknown}
prod_id=${board_details[1]:-0x00}
has_eeprom_fru=${board_details[2]:-false}

echo "Board ID: $board_id, Name: $name, Product ID: $prod_id, EEPROM: $has_eeprom_fru"

# Ensure EEPROM FRU is programmed properly; else use SPI based FRU as
# workaround.
if $has_eeprom_fru && ! is_board_eeprom_programmed
then
    has_eeprom_fru=false
    echo "Unprogrammed baseboard EEPROM FRU detected!!! Contact BMC team for programming instructions."
fi

if [ ! -f $PROD_ID_FILE ]
then
    echo $prod_id > $PROD_ID_FILE
else
    prev_id=$(cat $PROD_ID_FILE)
    if [ "$prev_id" != "$prod_id" ]
    then
        echo $prod_id > $PROD_ID_FILE
        echo "Platform ID change detected from $prev_id to $prod_id! Restoring BMC to default configuration."
        if ! restore_config
        then
            echo "Restore configuration failed!"
        fi
    fi
fi

if is_partition_boot
then
    echo "Partition Boot Mode enabled."
fi

#Remove old system.json file when the board is repurposed as different platform
if is_partition_boot && [ ! -e $PARTITION_BOOT_FLAG_FILE ]
then
    echo "Creating Partition boot flag file."
    touch $PARTITION_BOOT_FLAG_FILE
    rm -f $SYSTEM_JSON_FILE
elif ! is_partition_boot && [ -e $PARTITION_BOOT_FLAG_FILE ]
then
    echo "Partition Boot Mode disabled."
    rm -f $PARTITION_BOOT_FLAG_FILE $SYSTEM_JSON_FILE
fi

if is_r1s_present
then
    echo "R1S configuration detected. Creating flag file."
    touch $R1S_PRESENT_FLAG
else
    echo "R1S configuration not detected."
    rm -f $R1S_PRESENT_FLAG
fi

if $has_eeprom_fru
then
    # Remove baseboard filesystem FRU(if any), as this platform has EEPROM FRU.
    rm -f $FRU_FILE
    exit 0
fi

if [ ! -f $FRU_FILE ]
then
    cd /tmp || { echo "No /tmp!?"; exit 1; }
    mkdir -p $FRU_PATH
    mkfru "$name"
    mv "$name.fru.bin" $FRU_FILE
fi
