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
apt -y install build-essential wget pkg-config autoconf python3-sphinx e2fslibs-dev reiserfsprogs libblkid-dev liblzo2-dev zlib1g-dev libzstd-dev libudev-dev python3.7-dev

rm -rf build
mkdir -p build
cd build

wget https://github.com/kdave/btrfs-progs/archive/refs/tags/v${VERSION}.tar.gz --progress dot:giga
tar xf v${VERSION}.tar.gz

cd btrfs-progs-*
./autogen.sh
./configure --help
./configure --disable-convert --disable-python
make btrfs.box
mkdir -p $PREFIX
mv btrfs.box $PREFIX/btrfs
ls -la $PREFIX
chmod +x $PREFIX/btrfs
ldd $PREFIX/btrfs
$PREFIX/btrfs --help
cd ../..

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
