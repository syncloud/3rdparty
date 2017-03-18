#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

NAME=openssl
BUILD_DIR=${DIR}/build
PREFIX=${BUILD_DIR}/${NAME}
OPENSSL_VERSION=1.0.2k

apt-get install libffi-dev

rm -rf ${PREFIX}
mkdir -p ${PREFIX}
cd ${BUILD_DIR}

curl -O https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz

rm -rf openssl-${OPENSSL_VERSION}
tar xzf openssl-${OPENSSL_VERSION}.tar.gz
cd openssl-${OPENSSL_VERSION}

./config -Wl,--version-script=${DIR}/openssl.ld -Wl,-Bsymbolic-functions -fPIC shared

./config no-shared no-ssl2 -fPIC --prefix=${PREFIX}

make
make install

cd ${DIR}
rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${BUILD_DIR} ${NAME}
