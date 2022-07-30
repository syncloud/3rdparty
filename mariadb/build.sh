#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

ARCH=$(uname -m)
NAME=mariadb
VERSION=10.6.8
BUILD=${DIR}/build
PREFIX=${BUILD}/${NAME}

apt update
apt -y install build-essential cmake libncurses5-dev zlib1g-dev wget

rm -rf ${BUILD}
mkdir ${BUILD}
cd ${BUILD}

wget https://archive.mariadb.org/mariadb-${VERSION}/source/mariadb-${VERSION}.tar.gz \
    --progress dot:giga -O ${NAME}-${VERSION}.tar.gz
tar xzf ${NAME}-${VERSION}.tar.gz
cd ${NAME}-${VERSION}

cmake . -DCMAKE_INSTALL_PREFIX=${PREFIX}
make -j4
make install

export LD_LIBRARY_PATH=${PREFIX}/lib
cp $(readlink -f /lib*/ld-linux-*.so*) ${PREFIX}/lib/ld.so
cp /usr/lib/*/liblz4.so* ${PREFIX}/lib
cp /lib/*/libbz2.so* ${PREFIX}/lib
cp /lib/*/libcrypt.so* ${PREFIX}/lib
cp /usr/lib/*/libssl.so* ${PREFIX}/lib
cp /usr/lib/*/libcrypto.so* ${PREFIX}/lib
cp /lib/*/libncurses.so* ${PREFIX}/lib
cp /lib/*/libz.so* ${PREFIX}/lib
cp /lib/*/libpcre.so.* ${PREFIX}/lib
cp /usr/lib/*/libstdc++.so* ${PREFIX}/lib
cp /lib/*/libgcc_s.so* ${PREFIX}/lib
cp /lib/*/libtinfo.so* ${PREFIX}/lib

ldd ${PREFIX}/bin/mysqld
${PREFIX}/bin/mysqld --help

ldd ${PREFIX}/bin/mysql
${PREFIX}/bin/mysql --help

du -h --max-depth=1 ${PREFIX} | sort -h

cp ${DIR}/mariadb.sh ${PREFIX}/bin
rm -rf ${PREFIX}/mysql-test

rm -rf ${BUILD}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${BUILD} ${NAME}
