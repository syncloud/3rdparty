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
NAME=redis
VERSION=3.0.5
BUILD=${DIR}/build
PREFIX=${BUILD}/${NAME}

apt-get -y install build-essential cmake libncurses5-dev

rm -rf ${BUILD}
mkdir ${BUILD}
cd ${BUILD}
http://download.redis.io/releases/redis-3.0.5.tar.gz
wget http://download.redis.io/releases/${NAME}-${VERSION}.tar.gz \
    --progress dot:giga -O ${NAME}-${VERSION}.tar.gz
tar xzf ${NAME}-${VERSION}.tar.gz
cd ${NAME}-${VERSION}

make
make PREFIX=${PREFIX} install

rm -rf ${BUILD}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${BUILD} ${NAME}