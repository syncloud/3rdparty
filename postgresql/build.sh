#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

apt-get -y install dpkg-dev
ARCH=$(dpkg-architecture -qDEB_HOST_GNU_CPU)

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

cd ../..

rm -rf ${NAME}-${ARCH}.tar.gz
tar czf ${NAME}-${ARCH}.tar.gz -C ${ROOT} ${NAME}