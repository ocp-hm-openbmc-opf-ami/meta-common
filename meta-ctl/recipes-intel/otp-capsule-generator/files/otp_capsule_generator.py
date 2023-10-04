#!/usr/bin/env python3

# Copyright (c) 2023 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
import hashlib
import struct
import json
import sys
import io
import array
import binascii
import copy
import shutil
import re
import getopt
from array import array
from binascii import unhexlify
from hashlib import sha1, sha256, sha384, sha512
from shutil import copyfile

# Flash Map
# -----------------------------------------------
# Start addr      Contents
# 0x00000000  S+  PFM
# 0x00000800  U   staging-image
# * partially signed (not full 64k page)

# TODO: The below defines should go to manifest files.
# Keeping it here hard coded for now.
# The pages to be skipped for HASH and PBC
# Pages: 0x80 to 0x9f - starting PFM region until end of pfm
# Pages: 0x2a00 to 0x7FFF - starting RC-image until end of flash
EXCLUDE_PAGES = [[0x80, 0x9f], [0x2a00, 0x7fff]]

# SPI PFM globals
PFM_SPI = 0x1
PFM_DEF_SIZE = 32  # 32 bytes of PFM header
PFM_SPI_SIZE_DEF = 16  # 16 bytes of SPI PFM
PAGE_SIZE = 0x1000  # 4KB size of page
PFM_HEADER_SIZE = 1024 # 1KB size of PFM Header


def load_manifest(fname):
    manifest = {}
    with open(fname, 'r') as fd:
        manifest = json.load(fd)
    return manifest


class pfm_spi(object):

    def __init__(self, prot_mask, start_addr, end_addr, hash, hash_pres):
        self.spi_pfm = PFM_SPI
        self.spi_prot_mask = prot_mask
        self.spi_hash_pres = hash_pres
        print("hash_pres={}".format(self.spi_hash_pres))
        print("spi_hash={}".format(hash))
        print("spi_start_addr={}".format(start_addr))
        print("spi_end_addr={}".format(end_addr))
        if hash_pres != 0:
            self.spi_hash = hash
        self.spi_pfm_rsvd = 0xffffffff        # b'\xff'*4
        self.spi_start_addr = start_addr
        self.spi_end_addr = end_addr


class pfm_otp_image(object):

    # json_file, firmware_file
    def __init__(
            self,
            manifest,
            firmware_file,
            build_ver,
            build_num,
            build_hash,
            sha):

        self.manifest = load_manifest(manifest)
        self.firmware_file = firmware_file
        self.build_version = build_ver
        self.build_number = build_num
        self.build_hash = build_hash
        self.sha = sha
        if self.sha == "2":
            self.sha_version = 0x2
            self.pfm_spi_size_hash = 48
        if self.sha == "1":
            self.pfm_spi_size_hash = 32
            self.sha_version = 0x1

        self.page_size = PAGE_SIZE
        self.empty = b'\xff' * self.page_size

        self.image_parts = []
        for p in self.manifest['image-parts']:
            # the json should have in the order- filename, index, offset, size
            # and protection byte
            self.image_parts.append(
                (p['name'],
                 p['index'],
                    p['offset'],
                    p['size'],
                    p['prot_mask'],
                    p['pfm'],
                    p['hash'],
                    p['compress']))

        if self.sha == "1":
            self.act_dgst = hashlib.sha256()
        if self.sha == "2":
            self.act_dgst = hashlib.sha384()

        # SPI regions PFM array
        self.pfm_spi_regions = []
        # PFM definition bytes (SPI regions + SMBUS)
        self.pfm_bytes = PFM_DEF_SIZE

        self.sec_rev = 1

        # fill in the calculated data
        self.hash_and_map()

        # Generate PFM region binary - pfm.bin
        self.build_pfm()
        print("PFM build done")

    def hash_compress_regions(self, p):

        # JSON format as below
        # 0. "name": <image region name>
        # 1. "index": 1,
        # 2. "offset": <start addr>,
        # 3. "size": <size of the region>,
        # 4. "prot_mask": <protection mask>,
        # 5. "pfm": <1|0 -add in PFM or not>,
        # 6. "hash": <hashing of the region needed>,
        # 7. "compress": <region to be compressed>

        image_name = p[0]
        start_addr = int(p[2], 16)  # image part start address
        size = int(p[3], 16)  # size of the image part
        pfm_prot_mask = p[4]      # pfm protection mask
        pfm_flag = p[5]           # pfm needed?
        hash_flag = p[6]  # to be hashed?
        compress = p[7]  # compress flag
        index = p[1]              # image part index
        # 1 page is 4KB
        page = start_addr >> 12

        with open(self.firmware_file, "rb") as f:
            f.seek(start_addr)
            skip = False

            if hash_flag == 1:
                if self.sha == "1":
                    hash_dgst = hashlib.sha256()
                if self.sha == "2":
                    hash_dgst = hashlib.sha384()
            for chunk in iter(lambda: f.read(self.page_size), b''):
                chunk_len = len(chunk)
                if chunk_len != self.page_size:
                    chunk = b''.join(
                        [chunk, b'\xff' * (self.page_size - chunk_len)])

                for p in EXCLUDE_PAGES:
                    if (page >= p[0]) and (page <= p[1]):
                        #print("Exclude page={}".format(page))
                        skip = True
                        break

                if not skip:
                    # add to the hash
                    if hash_flag == 1:
                        # HASH for the region
                        self.act_dgst.update(chunk)
                        hash_dgst.update(chunk)

                page += 1

                if (page * self.page_size) >= (size + start_addr):
                    break

        if pfm_flag == 1:
            self.pfm_bytes += PFM_SPI_SIZE_DEF

            hash = bytearray(self.pfm_spi_size_hash)
            hash_pres = 0

            if hash_flag == 1:
                # region's hash
                hash = hash_dgst.hexdigest()
                hash_pres = self.sha_version
                self.pfm_bytes += self.pfm_spi_size_hash
            # append to SPI regions in PFM
            self.pfm_spi_regions.append(
                pfm_spi(
                    pfm_prot_mask,
                    start_addr,
                    (start_addr + size),
                    hash,
                    hash_pres))

    def hash_and_map(self):

        for p in self.image_parts:
            # filename, index, offset, size, protection.
            print(p[0], p[1], p[2], p[3], p[4])
            self.hash_compress_regions(p)

    def build_pfm(self):
        '''
        typedef struct {
            uint32_t tag;             /* PFM_HDR_TAG above, no terminating null */
            uint8_t SVN;     /* SVN- security revision of associated image data */
            uint8_t bkc;              /* bkc */
            uint8_t pfm_ver_major;    /* PFM revision */
            uint8_t pfm_ver_minor;
            uint8_t reserved0[4];
            uint8_t build_num;
            uint8_t build_hash[3];
            uint8_t  reserved1[12];       /* reserved */
            uint32_t pfm_length;      /* PFM size in bytes */
            pfm_spi  pfm_spi[2];          /* PFM SPI regions - u-boot & fit-image */
            pfm_smbus pfm_smbus[4];       /*  defined smbus rules for PSUs and HSBP */
        } __attribute__((packed)) pfm_hdr;
        '''
        names = [
            'tag',
            'sec_rev',
            'bkc',
            'pfm_ver_major',
            'pfm_ver_minor',
            'resvd0',
            'build_num',
            'build_hash1',
            'build_hash2',
            'build_hash3',
            'resvd1',
            'pfm_len',
        ]
        parts = {
            'tag': struct.pack("<I", 0x02b3ce1d),
            'sec_rev': struct.pack('<B', self.sec_rev),
            'bkc': struct.pack('<B', 0x01),
            'pfm_ver_major': struct.pack('<B', ((int(self.build_version) >> 8) & 0xff)),
            'pfm_ver_minor': struct.pack('<B', (int(self.build_version) & 0x00ff)),
            'resvd0': b'\xff' * 4,
            'build_num': struct.pack('<B', int(self.build_number, 16)),
            'build_hash1': struct.pack('<B', (int(self.build_hash) & 0xff)),
            'build_hash2': struct.pack('<B', ((int(self.build_hash) >> 8) & 0xff)),
            'build_hash3': struct.pack('<B', ((int(self.build_hash) >> 16) & 0xff)),
            'resvd1': b'\xff' * 12,
            'pfm_len': ''
        }

        # PFM should be 128bytes aligned, find the padding bytes
        padding_bytes = 0
        if (self.pfm_bytes % 512) != 0:
            padding_bytes = 512 - (self.pfm_bytes % 512)
        # `pdb.set_trace()
        print("padding={}".format(padding_bytes))
        print("PFM size1={}".format(self.pfm_bytes))
        self.pfm_bytes += padding_bytes
        parts['pfm_len'] = struct.pack('<I', self.pfm_bytes)
        print("PFM size2={}".format(self.pfm_bytes))
        padding_bytes = PFM_HEADER_SIZE - 112 # Size of PFM_HDR
        with open("pfm_header.bin", "wb+") as f:
            f.write(b''.join([parts[n] for n in names]))
            for i in self.pfm_spi_regions:
                f.write(struct.pack('<B', int(i.spi_pfm)))
                f.write(struct.pack('<B', int(i.spi_prot_mask)))
                f.write(struct.pack('<h', int(i.spi_hash_pres)))
                f.write(struct.pack('<I', int(i.spi_pfm_rsvd)))
                f.write(struct.pack('<I', int(i.spi_start_addr)))
                f.write(struct.pack('<I', int(i.spi_end_addr)))

                if i.spi_hash_pres != 0:
                    f.write(bytearray.fromhex(i.spi_hash))


            # write the padding bytes at the end
            f.write(b'\xff' * padding_bytes)


def usage(prog):
    sys.stderr.write(
        prog +
        " -m manifest -i rom-image -n build_version -b build_number -h build_hash -s sha -o output_file_name\n")


def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "m:i:n:b:h:s:o:", [
                                   "manifest=", "image=", "build_version=", "build_number=", "build_hash=", "sha=", "output_file_name="])
    except getopt.GetoptError as err:
        sys.stderr.write(str(err) + "\n")
        sys.exit(2)
    json_file = None
    firmware_file = None
    build_ver = None
    build_num = None
    build_hash = None
    sha = None

    for o, a in opts:
        if o in ("-m", "--manifest"):
            json_file = a
        elif o in ("-i", "--image"):
            firmware_file = a
        elif o in ("-n", "--build_version"):
            build_ver = a
        elif o in ("-b", "--build_number"):
            build_num = a
        elif o in ("-h", "--build_hash"):
            build_hash = a
        elif o in ("-s", "--sha"):
            sha = a
        else:
            usage(sys.argv[0])
            assert False, "unhandled argument: " + o

    if json_file is None or firmware_file is None or build_ver is None or build_num is None or build_hash is None or sha is None:
        usage(sys.argv[0])
        sys.exit(-1)

    print("manifest: %s" % json_file)
    print("image: %s" % firmware_file)
    print("build_ver: %s" % build_ver)
    print("build_number: %s" % build_num)
    print("build_hash: %s" % build_hash)
    print("Sha: %s" % sha)

    # function to generate BMC PFM, PBC header and BMC compressed image
    pfm_otp_image(
        json_file,
        firmware_file,
        build_ver,
        build_num,
        build_hash,
        sha)


if __name__ == '__main__':
    main()
