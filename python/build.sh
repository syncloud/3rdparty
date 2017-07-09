#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

VERSION=2.7.13

export TMPDIR=/tmp
export TMP=/tmp

NAME=python
PREFIX=${DIR}/build/${NAME}
OPENSSL=${DIR}/build/openssl

#apt-get update
apt-get -y install build-essential flex bison libreadline-dev zlib1g-dev libpcre3-dev libbz2-dev libsqlite3-dev unzip
apt-get remove libssl-dev
rm -rf build
mkdir build
cd ${DIR}/build

wget http://artifact.syncloud.org/3rdparty/openssl-${ARCH}.tar.gz
tar xf openssl-${ARCH}.tar.gz

# DANGEROUS to run outside of drone/docker
cp --remove-destination -r ${OPENSSL}/lib/*.so* /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/
cp --remove-destination -r ${OPENSSL}/include/openssl /usr/include/

wget https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tar.xz
tar xf Python-${VERSION}.tar.xz
cd Python-${VERSION}

#CPPFLAGS=-I${OPENSSL}/include \
#LDFLAGS=-L${OPENSSL}/lib \
./configure --prefix=${PREFIX} --enable-shared --enable-unicode=ucs4
make
make install

mv ${PREFIX}/bin/python ${PREFIX}/bin/python.bin
cp ${DIR}/python ${PREFIX}/bin/

${PREFIX}/bin/python -m ensurepip --upgrade
mv ${PREFIX}/bin/pip ${PREFIX}/bin/pip_runner
cp ${DIR}/pip ${PREFIX}/bin/

cp --remove-destination ${OPENSSL}/lib/libssl*.so* ${PREFIX}/lib
cp --remove-destination ${OPENSSL}/lib/libcrypto*.so* ${PREFIX}/lib

ldd ${PREFIX}/lib/python2.7/lib-dynload/_ssl.so

find ${PREFIX}/bin -type f -exec sed -i "s|#!${PREFIX}/|#!|g" {} \;
chmod +w ${PREFIX}/lib/libpython*
cd ${DIR}

find ${PREFIX} \( -name "*.pyc" -o -name "*.pyo" \) -exec rm {} \;
${PREFIX}/bin/python --version

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}