#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

NAME=mongodb
VERSION=3.4.10
PREFIX=${DIR}/build/${NAME}

echo "building ${NAME}"

rm -rf $PREFIX
mkdir -p $PREFIX
cd $DIR/build

ARCHIVE=${NAME}-src-r${VERSION}.tar.gz
wget https://fastdl.mongodb.org/src/${ARCHIVE} --progress dot:giga
tar xzf ${ARCHIVE}

cd ${NAME}-src-r${VERSION}
ls -la
cat README
./configure --prefix=${PREFIX}
make
make install

tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
