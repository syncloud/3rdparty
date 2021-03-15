#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

export TMPDIR=/tmp
export TMP=/tmp
NAME=bind9
VERSION=9.10.2
BUILD=${DIR}/build
PREFIX=${BUILD}/${NAME}

rm -rf ${BUILD}
mkdir ${BUILD}
cd ${BUILD}

apk add -U alpine-sdk linux-headers
wget ftp://ftp.isc.org/isc/bind9/${VERSION}/bind-${VERSION}.tar.gz
tar xf bind-${VERSION}.tar.gz
cd bind-${VERSION}
CFLAGS="-static -lunwind" ./configure --prefix=${PREFIX} --without-openssl --disable-symtable
make
make install
ldd ${PREFIX}/bin/dig
${PREFIX}/bin/dig --version
rm -rf ${BUILD}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${BUILD} ${NAME}
