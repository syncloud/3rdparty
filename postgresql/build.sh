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
NAME=postgresql
VERSION=9.4.20
PREFIX=${DIR}/build/${NAME}

apt-get -y install build-essential flex bison libreadline-dev zlib1g-dev

rm -rf build
mkdir -p build
cd build

wget https://ftp.postgresql.org/pub/source/v${VERSION}/${NAME}-${VERSION}.tar.bz2 --progress dot:giga
tar xjf ${NAME}-${VERSION}.tar.bz2
cd ${NAME}-${VERSION}
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

#cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libreadline.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libhistory.so* ${PREFIX}/lib
#cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libtinfo.so* ${PREFIX}/lib

echo "embedded libs"
export LD_LIBRARY_PATH=${PREFIX}/lib
ldd ${PREFIX}/bin/psql.bin

cd ../..

rm -rf ${NAME}-${ARCH}.tar.gz
tar czf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
