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

./configure --prefix ${PREFIX} LDFLAGS=-static
make world
make install

mv ${PREFIX}/bin/pg_dump ${PREFIX}/bin/pg_dump.bin
mv ${PREFIX}/bin/postgres ${PREFIX}/bin/postgres.bin
cp ${DIR}/bin/* ${PREFIX}/bin

echo "original libs"
ldd ${PREFIX}/bin/psql
LD=$(readlink -f /lib*/ld-linux-*)
cp $LD ${PREFIX}/lib/ld.so
cp /lib/*/libhistory.so* ${PREFIX}/lib
cp /lib/*/libtinfo.so* ${PREFIX}/lib
cp /lib/*/libpthread.so* ${PREFIX}/lib
cp /lib/*/librt.so* ${PREFIX}/lib
cp /lib/*/libm.so* ${PREFIX}/lib
cp /lib/*/libc.so* ${PREFIX}/lib
cp /lib/*/libreadline.so* ${PREFIX}/lib

echo "embedded libs"
export LD_LIBRARY_PATH=${PREFIX}/lib
ldd ${PREFIX}/bin/psql

cd ../..

tar czf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
