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
NAME=openvpn
VERSION=2.4.8
BUILD=${DIR}/build
PREFIX=${BUILD}/${NAME}

apt-get -y install liblzo2-dev libpam-dev

rm -rf ${BUILD}
mkdir ${BUILD}
cd ${BUILD}

wget https://swupdate.openvpn.org/community/releases/openvpn-${VERSION}.tar.gz  --progress dot:giga -O ${NAME}-${VERSION}.tar.gz
tar xzf ${NAME}-${VERSION}.tar.gz
cd ${NAME}-${VERSION}
./configure --prefix=${PREFIX}
make
make install

export LD_LIBRARY_PATH=${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/liblzo2.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypt*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl*.so* ${PREFIX}/lib

ldd ${PREFIX}/sbin/openvpn

rm -rf ${BUILD}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}-${VERSION}.tar.gz -C ${BUILD} ${NAME}
