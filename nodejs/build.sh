#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

echo "arch: $ARCH"

if [ ${ARCH} == "x86_64" ]; then
    NODE_ARCH=x64
else
    NODE_ARCH=${ARCH}
fi

echo "node arch: ${NODE_ARCH}"

export TMPDIR=/tmp
export TMP=/tmp
NAME=nodejs
VERSION=8.9.0
BUILD=${DIR}/build
PREFIX=${BUILD}/${NAME}
NODE_ARCHIVE=node-v${VERSION}-linux-${NODE_ARCH}

rm -rf ${BUILD}
mkdir ${BUILD}
cd ${BUILD}

wget https://nodejs.org/dist/v${VERSION}/${NODE_ARCHIVE}.tar.gz \
    --progress dot:giga -O ${NAME}-${VERSION}.tar.gz
tar xzf ${NAME}-${VERSION}.tar.gz
mv ${NODE_ARCHIVE} ${NAME}

mv ${BUILD}/${NAME}/bin/npm ${BUILD}/${NAME}/bin/npm.js
cp ${DIR}/bin/npm ${BUILD}/${NAME}/bin/npm

${BUILD}/${NAME}/bin/npm

rm -rf ${BUILD}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${BUILD} ${NAME}
