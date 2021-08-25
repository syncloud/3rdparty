#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

ARCH=$(uname -m)
NAME=openssl
BUILD_DIR=${DIR}/build
PREFIX=${BUILD_DIR}/${NAME}
OPENSSL_VERSION=1.1.1h

apt update
apt -y install build-essential libffi-dev

rm -rf ${PREFIX}
mkdir -p ${PREFIX}
cd ${BUILD_DIR}

curl -O https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz

rm -rf openssl-${OPENSSL_VERSION}
tar xzf openssl-${OPENSSL_VERSION}.tar.gz
cd openssl-${OPENSSL_VERSION}

./config --prefix=${PREFIX} --openssldir=/usr/lib/ssl no-shared no-ssl2 no-ssl3 -fPIC
make
make install

mv ${PREFIX}/bin/openssl ${PREFIX}/bin/openssl.bin
cp ${DIR}/openssl ${PREFIX}/bin/openssl

${PREFIX}/bin/openssl version -a

cd ${DIR}
rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${BUILD_DIR} ${NAME}
