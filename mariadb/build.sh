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
NAME=mariadb
VERSION=10.3.23
BUILD=${DIR}/build
PREFIX=${BUILD}/${NAME}

apt-get -y install build-essential cmake libncurses5-dev zlib1g-dev

cat /etc/apt/sources.list
strings /lib/x86_64-linux-gnu/libc.so.* | grep GLIBC

rm -rf ${BUILD}
mkdir ${BUILD}
cd ${BUILD}

wget https://downloads.mariadb.org/f/${NAME}-${VERSION}/source/${NAME}-${VERSION}.tar.gz \
    --progress dot:giga -O ${NAME}-${VERSION}.tar.gz
tar xzf ${NAME}-${VERSION}.tar.gz
cd ${NAME}-${VERSION}

cmake . -DCMAKE_INSTALL_PREFIX=${PREFIX}
make -j4
make install

export LD_LIBRARY_PATH=${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/liblz4.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libbz2.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypt.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypto.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libncurses.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libz.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpcre.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libstdc++.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgcc_s.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libtinfo.so* ${PREFIX}/lib

ldd ${PREFIX}/bin/mysqld
${PREFIX}/bin/mysqld --help

ldd ${PREFIX}/bin/mysql
${PREFIX}/bin/mysql --help

du -h --max-depth=1 ${PREFIX} | sort -h

cp ${DIR}/mariadb.sh ${PREFIX}/bin
rm -rf ${PREFIX}/mysql-test

rm -rf ${BUILD}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${BUILD} ${NAME}
