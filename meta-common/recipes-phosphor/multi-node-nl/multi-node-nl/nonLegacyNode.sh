#!/bin/bash

#
# Copyright (c) 2022 Intel Corporation
#
# This software and the related documents are Intel copyrighted
# materials, and your use of them is governed by the express license
# under which they were provided to you ("License"). Unless the
# License provides otherwise, you may not use, modify, copy, publish,
# distribute, disclose or transmit this software or the related
# documents without Intel's prior written permission.
#
# This software and the related documents are provided as is, with no
# express or implied warranties, other than those that are expressly
# stated in the License.
#

PWM_FILE="/sys/class/hwmon/hwmon0/pwm"
FAN_SPEED=$((255 * 80 / 100))

set_fan_speed() {
    local idx=0
    for ((idx=1; idx<=8; idx++))
    do
        if [ -f $PWM_FILE$idx ]; then
            echo $FAN_SPEED > $PWM_FILE$idx
        fi
    done
}

$(set_fan_speed)

#Stop power control service in NL mode
systemctl stop  xyz.openbmc_project.Chassis.Control.Power.service

export TERM=xterm
# Autologin root user to serial console (ttyS4) on boot
exec /sbin/agetty -a root -J -8 -L ttyS4 115200 $TERM
