#!/bin/sh

ARCH=$1
NAME=bind9
VERSION=9.16.0
BUILD=build
PREFIX=${BUILD}/${NAME}

apk add -U alpine-sdk

wget ftp://ftp.isc.org/isc/bind9/${VERSION}/bind-${VERSION}.tar.xz
tar xf bind-${VERSION}.tar.xz
cd bind-${VERSION}
export CFLAGS="-static"
./configure --prefix=${PREFIX} --without-python
make
make install
ldd ${PREFIX}/bin/dig
cd ..
tar czf ${NAME}-${ARCH}.tar.gz -C ${BUILD} ${NAME}
