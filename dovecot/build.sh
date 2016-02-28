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
VERSION=2.2.21
BUILD=${DIR}/build
PREFIX=${BUILD}/${NAME}

apt-get -y install build-essential cmake libncurses5-dev

rm -rf ${BUILD}
mkdir ${BUILD}
cd ${BUILD}

wget http://www.dovecot.org/releases/2.2/${NAME}-${VERSION}.tar.gz \
    --progress dot:giga
tar xzf ${NAME}-${VERSION}.tar.gz
cd ${NAME}-${VERSION}

./configure --prefix=${PREFIX}
make
make install

rm -rf ${BUILD}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${BUILD} ${NAME}