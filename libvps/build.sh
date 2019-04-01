#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1
LIB_ARCH=linux-armv6
if [[ ${ARCH} == "amd64" ]]; then
    LIB_ARCH=linux-x64
fi

NAME=lobvps
VERSION=8.7.4
PREFIX=${DIR}/build/${NAME}

rm -rf ${DIR}/build
mkdir -p $PREFIX
cd ${DIR}/build

echo "building ${NAME}"

wget https://github.com/libvips/libvips/releases/download/v${VERSION}/vips-${VERSION}.tar.gz
tar xf vips-${VERSION}.tar.gz
cd vips-${VERSION}
./configure --prefix=${PREFIX}
make
make install

ls -la ${PREFIX}
ls -la ${PREFIX}/bin
ls -la ${PREFIX}/lib

cd ${DIR}

tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
