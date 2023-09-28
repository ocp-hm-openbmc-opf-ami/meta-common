#!/usr/bin/env python3
#
# Copyright (c) 2020-2022 Intel Corporation
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

import sys
import os
import subprocess


def get_current_file_path(current_file_location):
    curr_file_name = os.path.basename(__file__)
    dest_file_location = current_file_location.split(curr_file_name)
    return dest_file_location[0]


def parse_config_file_and_get_property(current_file_location, property):
    path_dict = {}
    dest_file_location = get_current_file_path(current_file_location)
    config_file_name = dest_file_location + 'ast2600/ast2600-secureboot-config.cfg'
    file = open(config_file_name, 'r')
    content = file.read()
    paths = content.split("\n")  # split it into lines
    for path in paths:
        p = path.split("=")
        if len(p) >= 2:
            path_dict[p[0]] = p[1]
    property = path_dict[property]
    file.close()
    property = property.replace('"', '')
    return property


def main(argv):
    key_name = parse_config_file_and_get_property(argv[0], 'PRIVATE_KEY_NAME')
    secure_keys = parse_config_file_and_get_property(argv[0], 'SECURE_KEYS')
    hash_algo = parse_config_file_and_get_property(argv[0], 'ROT_ALGORITHM')
    #expected hash_algo value is expected in RSAalgo_HASHalgo format
    hash_algo = hash_algo.split('_')[1].lower()
    if secure_keys == '1':
        p = subprocess.Popen(
            ['external-signing-utility', 'sign', key_name, hash_algo, argv[2], argv[2]])
    else:
        p = subprocess.Popen(['external-signing-utility',
                              'debug',
                              'sign',
                              key_name,
                              hash_algo,
                              argv[2],
                              argv[2]])

    retcode = p.wait()
    if retcode != 0:
        raise ValueError('Error signing')


if __name__ == "__main__":
    sys.exit(main(sys.argv))
