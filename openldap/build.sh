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
NAME=openldap
VERSION=2.4.44
BUILD_DIR=${DIR}/build
PREFIX=${BUILD_DIR}/${NAME}

echo "building ${NAME}"

apt-get -y install build-essential flex bison libreadline-dev zlib1g-dev libpcre3-dev libdb5.3-dev libsasl2-dev

rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

wget http://www.openldap.org/software/download/OpenLDAP/openldap-release/${NAME}-${VERSION}.tgz --progress dot:giga
tar xzf ${NAME}-${VERSION}.tgz
cd ${NAME}-${VERSION}
./configure --prefix=${PREFIX}
make -j2
make install
mkdir ${PREFIX}/slapd.d

cd ${DIR}
rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${BUILD_DIR} ${NAME}