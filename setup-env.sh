#! /bin/sh
# 
# Set environment variables prior to build
#

export PATH=$PATH:$PWD/build/native/bin
export PSEUDO_PREFIX=${PWD}/build/native/

export BOARD=raspberrypi4

# boot partition (fat)
export BOOT_PARTITION_SIZE_MB=16

# root partition (ext2)
export ROOT_PARTITION_SIZE_MB=128

