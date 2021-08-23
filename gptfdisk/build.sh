#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

ARCH=$(uname -m)
NAME=gptfdisk
VERSION=1.0.4
BUILD=${DIR}/build
PREFIX=${BUILD}/${NAME}

apt update
apt -y install build-essential libpopt-dev libncurses5-dev libncursesw5-dev uuid-dev

rm -rf ${BUILD}
mkdir ${BUILD}
cd ${BUILD}

wget http://www.rodsbooks.com/gdisk/gptfdisk-${VERSION}.tar.gz
tar xf gptfdisk-${VERSION}.tar.gz
cd gptfdisk-${VERSION}
make
mkdir ${PREFIX}
mkdir ${PREFIX}/bin
cp gdisk ${PREFIX}/bin
cp sgdisk ${PREFIX}/bin
mkdir ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libuuid.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libstdc++.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgcc_s.so* ${PREFIX}/lib

rm -rf ${BUILD}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${BUILD} ${NAME}
