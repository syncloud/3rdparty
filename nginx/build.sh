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
NAME=nginx
VERSION=1.8.0
OPENSSL_VERSION=1.0.1e
ROOT=/opt/app/platform
PREFIX=${ROOT}/${NAME}

echo "building ${NAME}"

apt-get -y install build-essential flex bison libreadline-dev zlib1g-dev libpcre3-dev

rm -rf build
mkdir -p build
cd build

wget http://nginx.org/download/${NAME}-${VERSION}.tar.gz --progress dot:giga
tar xzf ${NAME}-${VERSION}.tar.gz

wget http://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
tar xzf openssl-${OPENSSL_VERSION}.tar.gz

cd openssl-${OPENSSL_VERSION}

sed -i 's/install: all install_docs install_sw/install: all install_sw/g' Makefile.org
./config

cd ..

cd ${NAME}-${VERSION}
./configure --prefix=${PREFIX} --with-cc-opt="-static -static-libgcc" --with-ld-opt="-static" --with-http_ssl_module --with-http_gzip_static_module --with-http_spdy_module --with-openssl=../openssl-${OPENSSL_VERSION}
make -j1
rm -rf ${PREFIX}
make install_sw
cd ../..

ldd ${PREFIX}/sbin/nginx

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${ROOT} ${NAME}
