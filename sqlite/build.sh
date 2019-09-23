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
NAME=sqlite
VERSION=3290000
BUILD=${DIR}/build
PREFIX=${BUILD}/${NAME}

rm -rf ${BUILD}
mkdir ${BUILD}
cd ${BUILD}
wget https://www.sqlite.org/2019/sqlite-autoconf-${VERSION}.tar.gz --progress dot:giga
tar xzf sqlite-autoconf-${VERSION}.tar.gz
cd sqlite-autoconf-${VERSION}

./configure --prefix=${PREFIX}
make
make install

rm -rf ${BUILD}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${BUILD} ${NAME}
