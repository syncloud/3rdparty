#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

ARCH=$(uname -m)

export TMPDIR=/tmp
export TMP=/tmp
NAME=nginx
VERSION=1.20.1
OPENSSL_VERSION=1.1.1
PCRE_VERSION=8.40
PREFIX=${DIR}/build/nginx

apt update
apt -y install build-essential flex bison libreadline-dev zlib1g-dev

rm -rf build
mkdir -p build
cd build

wget http://nginx.org/download/${NAME}-${VERSION}.tar.gz --progress dot:giga
tar xzf ${NAME}-${VERSION}.tar.gz

wget http://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
tar xzf openssl-${OPENSSL_VERSION}.tar.gz

wget https://ftp.pcre.org/pub/pcre/pcre-${PCRE_VERSION}.tar.gz
tar xzf pcre-${PCRE_VERSION}.tar.gz

cd ${NAME}-${VERSION}
./configure --prefix=${PREFIX} \
    --with-cpu-opt=generic \
    --with-cc-opt="-static -static-libgcc" \
    --with-ld-opt="-static" \
    --with-http_ssl_module \
    --with-http_gzip_static_module \
    --with-openssl=../openssl-${OPENSSL_VERSION} \
    --with-pcre=../pcre-${PCRE_VERSION} \
    --with-ipv6 \
    --with-http_realip_module \
    --with-http_v2_module \
    --with-openssl-opt=no-asm

sed -i "/CFLAGS/s/ \-O //g" objs/Makefile

make -j1
rm -rf ${PREFIX}
make install
cd ../..

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
