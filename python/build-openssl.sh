#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

OPENSSL_VERSION=1.0.2h
OPENSSL_ROOT=${DIR}/build/openssl

apt-get install libffi-dev

rm -rf openssl-${OPENSSL_VERSION}
curl -O https://openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
tar xvf openssl-${OPENSSL_VERSION}.tar.gz
cd openssl-${OPENSSL_VERSION}

#./config -Wl,--version-script=openssl.ld -Wl,-Bsymbolic-functions -fPIC shared

./config shared --prefix=${OPENSSL_ROOT}
make && make install
