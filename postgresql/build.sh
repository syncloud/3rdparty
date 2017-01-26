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
VERSION=9.4.2
ROOT=/opt/app/owncloud
PREFIX=${ROOT}/postgresql

apt-get -y install build-essential flex bison libreadline-dev zlib1g-dev

rm -rf build
mkdir -p build
cd build

wget https://ftp.postgresql.org/pub/source/v${VERSION}/${NAME}-${VERSION}.tar.bz2 --progress dot:giga
tar xjf ${NAME}-${VERSION}.tar.bz2
cd ${NAME}-${VERSION}
rm -rf ${PREFIX}

./configure --prefix ${PREFIX}
make
make install

mv ${PREFIX}/bin/pg_ctl ${PREFIX}/bin/pg_ctl.bin
cp ${DIR}/bin/* ${PREFIX}/bin
 
cd ../..

rm -rf ${NAME}-${ARCH}.tar.gz
tar czf ${NAME}-${ARCH}.tar.gz -C ${ROOT} ${NAME}
