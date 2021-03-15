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
VERSION=9.11.5
BUILD=${DIR}/build
PREFIX=${BUILD}/${NAME}

rm -rf ${BUILD}
mkdir ${BUILD}
cd ${BUILD}

apt-get -y install libxml2-dev

wget ftp://ftp.isc.org/isc/bind9/${VERSION}/bind-${VERSION}.tar.gz
tar xzf bind-${VERSION}.tar.gz
cd bind-${VERSION}
export CFLAGS="-static"
./configure --prefix=${PREFIX} --libdir=/usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)  --without-python --without-openssl --disable-symtable
make
make install
ldd ${PREFIX}/bin/dig
rm -rf ${BUILD}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${BUILD} ${NAME}
