#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

${DIR}/build/btrfs/bin/btrfs.sh --help
${DIR}/build/btrfs/bin/btrfs.sh version
${DIR}/build/btrfs/bin/mkfs.sh --help

ldd ${DIR}/build/btrfs/bin/btrfs.box
ldd ${DIR}/build/btrfs/bin/mkfs.btrfs