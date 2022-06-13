#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

ARCH=$(uname -m)

export TMPDIR=/tmp
export TMP=/tmp
NAME=btrfs
VERSION=5.18.1
PREFIX=${DIR}/build/${NAME}

apt update
apt -y install build-essential wget

rm -rf build
mkdir -p build
cd build

wget https://github.com/kdave/btrfs-progs/archive/refs/tags/v${VERSION}.tar.gz --progress dot:giga
tar xf v${VERSION}.tar.gz

cd btrfs-progs-*
./autogen.sh
./configure
make btrfs.box
mv btrfs.box $PREFIX/btrfs
./$PREFIX/btrfs --help
cd ../..

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
