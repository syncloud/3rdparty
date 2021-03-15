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

cp $(readlink -f /lib*/ld-linux-*.so*) ${DIR}/lib/ld.so

cp /usr/lib/*/libssl.so* ${PREFIX}/lib
cp /usr/lib/*/libcrypto.so* ${PREFIX}/lib
cp /usr/lib/*/libxml2.so* ${PREFIX}/lib
cp /usr/lib/*/libuv.so* ${PREFIX}/lib
cp /lib/*/librt.so* ${PREFIX}/lib
cp /lib/*/libpthread.so* ${PREFIX}/lib
cp /lib/*/libnsl.so* ${PREFIX}/lib
cp /lib/*/libdl.so* ${PREFIX}/lib
cp /lib/*/libc.so* ${PREFIX}/lib
cp /usr/lib/*/libicui18n.so* ${PREFIX}/lib
cp /usr/lib/*/libicuuc.so* ${PREFIX}/lib
cp /usr/lib/*/libicudata.so* ${PREFIX}/lib
cp /lib/*/libz.so* ${PREFIX}/lib
cp /lib/*/liblzma.so* ${PREFIX}/lib
cp /lib/*/libm.so* ${PREFIX}/lib
cp /usr/lib/*/libstdc++.so* ${PREFIX}/lib
cp /lib/*/libgcc_s.so* ${PREFIX}/lib

cp ${DIR}/dig.sh ${PREFIX}/bin/
${PREFIX}/bin/dig.sh -v

rm -rf ${BUILD}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${BUILD} ${NAME}
