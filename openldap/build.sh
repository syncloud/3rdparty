#!/bin/bash


DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

export TMPDIR=/tmp
export TMP=/tmp
NAME=openldap
VERSION=2.4.40
ROOT=/opt/app/platform
PREFIX=${ROOT}/${NAME}

echo "building ${NAME}"

apt-get -y install build-essential flex bison libreadline-dev zlib1g-dev libpcre3-dev libdb5.3-dev libsasl2-dev

rm -rf build
mkdir -p build
cd build

wget http://www.openldap.org/software/download/OpenLDAP/openldap-release/${NAME}-${VERSION}.tgz --progress dot:giga
tar xzf ${NAME}-${VERSION}.tgz
cd ${NAME}-${VERSION}
./configure --prefix=${PREFIX}
make -j2
rm -rf ${PREFIX}
make install
mkdir ${PREFIX}/slapd.d
cd ../..

rm -rf ${NAME}.tar.gz
tar cpzf ${NAME}.tar.gz -C ${ROOT} ${NAME}