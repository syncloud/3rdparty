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
VERSION=9.16.11
BUILD=${DIR}/build
PREFIX=${BUILD}/${NAME}

rm -rf ${BUILD}
mkdir ${BUILD}
cd ${BUILD}

apt-get update
apt-get -y install libxml2-dev libuv1-dev wget xz-utils build-essential pkg-config libssl-dev

wget ftp://ftp.isc.org/isc/bind9/${VERSION}/bind-${VERSION}.tar.xz
tar xf bind-${VERSION}.tar.xz
cd bind-${VERSION}
#export CFLAGS="-static"
./configure --prefix=${PREFIX} --without-python --without-openssl --disable-symtable --disable-linux-caps
make
make install
ldd ${PREFIX}/bin/dig
rm -rf ${BUILD}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${BUILD} ${NAME}
