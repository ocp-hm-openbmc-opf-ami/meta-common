#!/bin/sh

# Copyright 2017-2020 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#

ROUTER=$(echo /sys/bus/platform/drivers/aspeed-uart-routing/*.uart-routing)
[ -L "$ROUTER" ] || exit 2

route() {
    echo -n "$1" > "$ROUTER/$2"
    echo -n "$2" > "$ROUTER/$1"
}

setup_routing() {
    echo "Enabling UART routing"

    route uart1 uart3
    route uart4 io1
}

setup() {
    hostserialcfg=$(fw_printenv hostserialcfg 2> /dev/null)
    hostserialcfg=${hostserialcfg##*=}

    if [ "$hostserialcfg" = 1 ]
    then
        baud=921600
    else
        baud=115200
    fi

    echo "Configuring host UART for $baud baud"

    CONSOLE_CONF=/etc/obmc-console/server.ttyS2.conf
    cat > $CONSOLE_CONF <<-EOF
	# Autogenerated by $0
	baud = $baud
	local-tty = ttyS3
	local-tty-baud = $baud
	console-id = default
	EOF
}

teardown() {
    echo "Disabling UART routing"
    route uart1 io1
    route uart3 io3
    route uart4 io4
}

$1
