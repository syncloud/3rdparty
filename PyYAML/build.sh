#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

export TMPDIR=/tmp
export TMP=/tmp
NAME=PyYAML
VERSION=3.11
ROOT=${DIR}/build
PREFIX=${ROOT}/${NAME}

echo "repacking ${NAME}"

rm -rf build
mkdir -p build
cd build

wget https://pypi.python.org/packages/source/P/${NAME}/${NAME}-${VERSION}.tar.gz
tar xzf ${NAME}-${VERSION}.tar.gz
mv ${NAME}-${VERSION} ${NAME}-${VERSION}.orig
mkdir ${NAME}-${VERSION}
cp -r ${NAME}-${VERSION}.orig/lib/* ${NAME}-${VERSION}
cd ${DIR}

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${ROOT} ${NAME}-${VERSION}