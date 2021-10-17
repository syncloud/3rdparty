#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}


ARCH=$(uname -m)

export TMPDIR=/tmp
export TMP=/tmp
NAME=opendkim
VERSION=2.10.3
BUILD=${DIR}/build
PREFIX=${BUILD}/${NAME}

apt update
apt-get -y install libbsd-dev libmilter-dev wget build-essential openssl


rm -rf ${BUILD}
mkdir ${BUILD}
cd ${BUILD}

wget https://downloads.sourceforge.net/project/opendkim/opendkim-${VERSION}.tar.gz  --progress dot:giga -O ${NAME}-${VERSION}.tar.gz
tar xzf ${NAME}-${VERSION}.tar.gz
cd ${NAME}-${VERSION}
./configure --prefix=${PREFIX}
make
make install

ls -la ${PREFIX}
ls -la ${PREFIX}/lib
ls -la ${PREFIX}/sbin

export LD_LIBRARY_PATH=${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libbsd.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libmilter*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypt*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl*.so* ${PREFIX}/lib

ldd ${PREFIX}/sbin/opendkim

${PREFIX}/sbin/opendkim --help || true
${PREFIX}/sbin/opendkim-genkey --help || true

rm -rf ${BUILD}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}-${VERSION}.tar.gz -C ${BUILD} ${NAME}

tar czf ${DIR}/${NAME}-${ARCH}-${VERSION}.tar.gz -C ${BUILD} ${NAME}
