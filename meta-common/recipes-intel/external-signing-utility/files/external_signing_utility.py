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


def read_file(fileName, mode):
    try:
        with open(fileName, mode) as file:
            fileContent = file.read()
            return fileContent
    except BaseException:
        return None


def write_file(data, fileName, mode):
    file = open(fileName, mode)
    file.write(data)
    file.close()


def gen_key_pairs(prv_file_path, dest_file_path):
    prv_key_gen_cmd = 'openssl ecparam -genkey -name secp384r1 -out ' + prv_file_path
    pub_key_gen_cmd = 'openssl ec -in ' + \
        prv_file_path + ' -pubout -out ' + dest_file_path
    rc = subprocess.check_call(prv_key_gen_cmd, shell=True)
    if not rc:
        rc = subprocess.check_call(pub_key_gen_cmd, shell=True)
        if rc:
            sys.exit(1)
    else:
        sys.exit(1)


def gen_cert_cmds(prv_key_path, rk_csr_path, dest_file_name):
    cert_param = "/CN=intel test ECP384 CA"
    cert_param = '"{}"'.format(cert_param)
    rk_csr_gen_cmd = 'openssl req -new -sha384 -key ' + \
        prv_key_path + ' -out ' + rk_csr_path + ' -subj ' + cert_param
    rk_cert_gen = 'openssl x509 -req -days 365 -in ' + rk_csr_path + \
        ' -signkey ' + prv_key_path + ' -sha384 -out ' + dest_file_name
    rc = subprocess.check_call(rk_csr_gen_cmd, shell=True)
    if not rc:
        rc = subprocess.check_call(rk_cert_gen, shell=True)
        if rc:
            sys.exit(1)
    else:
        sys.exit(1)


def get_debug_keys(source_file, dest_file_name):
    source_file_contents = read_file(source_file, mode='r')
    if source_file_contents is not None:
        write_file(source_file_contents, dest_file_name, mode='w')
        return
    file_path = os.path.split(dest_file_name)
    '''
    Generate keys runtime
    '''
    if 'csk' in source_file:
        prv_key_path = file_path[0] + '/csk_prv.pem'
        gen_key_pairs(prv_key_path, dest_file_name)
    elif 'rk' in source_file and 'cert' not in source_file:
        prv_key_path = file_path[0] + '/rk_prv.pem'
        gen_key_pairs(prv_key_path, dest_file_name)
    elif 'rk' in source_file and 'cert' in source_file:
        prv_key_path = file_path[0] + '/rk_prv.pem'
        rk_csr_path = file_path[0] + '/rk_cert.csr'
        gen_cert_cmds(prv_key_path, rk_csr_path, dest_file_name)
    return


def developer_sign(
        current_loc,
        private_key,
        hash_type,
        hash_file,
        sign_file_out):
    data = read_file(hash_file, mode='rb')
    if not os.path.isfile(private_key):
        cwd = os.getcwd()
        if 'csk' in private_key:
            private_key = cwd + '/csk_prv.pem'
        elif 'rk' in private_key:
            private_key = cwd + '/rk_prv.pem'
    p = subprocess.Popen(['openssl',
                          'pkeyutl',
                          '-sign',
                          '-inkey',
                          private_key],
                         stdin=subprocess.PIPE,
                         stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE)
    (pout, perr) = p.communicate(input=data)
    retcode = p.wait()
    if retcode != 0:
        raise ValueError('Error signing: {}'.format(perr))
    signature = bytearray(pout)
    write_file(signature, sign_file_out, mode='wb+')


def debug_sign(argv):
    if argv[2] == 'get_key':
        if len(argv) < 4:
            usage(argv[0])
        return get_debug_keys(argv[3], argv[4])
    elif argv[2] == 'sign':
        if len(argv) < 6:
            usage(argv[0])
        return developer_sign(
            argv[0],
            argv[3],
            argv[4],
            argv[5],
            argv[6])


def usage(p):
    usage = """Usage: {} <cmd> <key-id> [args...]
      this is the key access api for the key server
      any executable with this name and functionality
      can serve in its place, making it a very extensible
      keys serving system
      Actions
      sign     - read hash on stdin and write signature on stdout
      debug    - read key from give location and writes to an output file
      get_key  - Installs the key to specified location
    """.format(p)
    print(usage)
    sys.exit(1)


def main(argv):
    args = []
    a = 0
    while a < len(argv):
        if argv[a] == '-v':
            try:
                # this can throw for out-of-bounds or conversion error
                verbose = int(argv[a + 1])
                a += 2
            except BaseException:
                # either way, ignore it and only increment verbosity
                verbose += 1
                a += 1
            continue
        args.append(argv[a])
        a += 1
    argv = args
    verbose = 10

    if len(argv) < 2:
        usage(argv[0])

    if argv[1] == 'debug':
        return debug_sign(argv)


if __name__ == "__main__":
    sys.exit(main(sys.argv))
