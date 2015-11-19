#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

export TMPDIR=/tmp
export TMP=/tmp
NAME=postfix
VERSION=2.11.7
BUILD_DIR=./build

echo "building ${NAME}"

printf "\ndeb-src http://httpredir.debian.org/debian jessie main contrib non-free" >> /etc/apt/sources.list
apt-get -y update
apt-get -y install build-essential
apt-get -y build-dep postfix

rm -rf build
mkdir -p build
cd build

wget ftp://ftp.reverse.net/pub/postfix/official/${NAME}-${VERSION}.tar.gz --progress dot:giga
tar xf ${NAME}-${VERSION}.tar.gz
cd ${NAME}-${VERSION}

rm -rf ${BUILD_DIR}

make
make non-interactive-package install_root=${BUILD_DIR}/${NAME}

cd ../..

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C build/${NAME}-${VERSION}/${BUILD_DIR} ${NAME}
