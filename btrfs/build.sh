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
mkdir -p $PREFIX/bin
mkdir -p $PREFIX/lib
mv btrfs.box $PREFIX/bin/btrfs
chmod +x $PREFIX/bin/btrfs
ldd $PREFIX/bin/btrfs

cp $(readlink -f /lib*/ld-linux-*.so*) ${PREFIX}/lib/ld.so
cp /lib/*/libuuid.so* ${PREFIX}/lib
cp /lib/*/libblkid.so* ${PREFIX}/lib
cp /lib/*/libudev.so* ${PREFIX}/lib
cp /lib/*/libz.so* ${PREFIX}/lib
cp /lib/*/liblzo2.so* ${PREFIX}/lib
cp /lib/*/libpthread.so* ${PREFIX}/lib
cp /lib/*/libc.so* ${PREFIX}/lib
cp /lib/*/librt.so* ${PREFIX}/lib
cp /usr/lib/*/libzstd.so* ${PREFIX}/lib

cp ${DIR}/btrfs.sh ${PREFIX}/bin/

cd ../..

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
