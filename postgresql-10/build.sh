#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}


ARCH=$(uname -m)
NAME=postgresql-10
VERSION=10.10
PREFIX=${DIR}/build/${NAME}

apt-get update
apt-get -y install build-essential flex bison libreadline-dev zlib1g-dev wget

rm -rf build
mkdir -p build
cd build

wget https://ftp.postgresql.org/pub/source/v${VERSION}/postgresql-${VERSION}.tar.bz2 --progress dot:giga
tar xjf postgresql-${VERSION}.tar.bz2
cd postgresql-${VERSION}
rm -rf ${PREFIX}

./configure --prefix ${PREFIX}
make world
make install

mv ${PREFIX}/bin/pg_ctl ${PREFIX}/bin/pg_ctl.bin
mv ${PREFIX}/bin/psql ${PREFIX}/bin/psql.bin
mv ${PREFIX}/bin/pg_dumpall ${PREFIX}/bin/pg_dumpall.bin
cp ${DIR}/bin/* ${PREFIX}/bin

echo "original libs"
ldd ${PREFIX}/bin/psql.bin

cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libreadline.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libhistory.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libtinfo.so* ${PREFIX}/lib

echo "embedded libs"
export LD_LIBRARY_PATH=${PREFIX}/lib
ldd ${PREFIX}/bin/psql.bin

cd ../..

tar czf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
