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
VERSION=10.0.21
BUILD=${DIR}/build
PREFIX=${BUILD}/${NAME}

apt-get -y install build-essential cmake

rm -rf ${BUILD}
mkdir ${BUILD}
cd ${BUILD}

wget https://downloads.mariadb.org/f/${NAME}-${VERSION}/source/${NAME}-${VERSION}.tar.gz/from/http%3A/mirrors.coreix.net/mariadb?serve \
    --progress dot:giga -O ${NAME}-${VERSION}.tar.gz
tar xzf ${NAME}-${VERSION}.tar.gz
cd ${NAME}-${VERSION}


cmake . -DCMAKE_INSTALL_PREFIX=${PREFIX}
make
make install

cd ${BUILD}

rm -rf ${NAME}-${ARCH}.tar.gz
tar czf ${NAME}-${ARCH}.tar.gz ${NAME}