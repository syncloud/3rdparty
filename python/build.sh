#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

VERSION=2.7.10
OPENSSL_VERSION=1.0.2g

NAME=python
PREFIX=${DIR}/build/${NAME}
OPENSSL=${DIR}/build/openssl

apt-get -y install build-essential flex bison libreadline-dev zlib1g-dev libpcre3-dev libbz2-dev libsqlite3-dev unzip libffi-dev

rm -rf build
mkdir build

cd ${DIR}/build
curl -O https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
tar xf openssl-${OPENSSL_VERSION}.tar.gz
cd openssl-${OPENSSL_VERSION}
./config --prefix=${OPENSSL} --openssldir=/usr/lib/ssl shared
make
make install

cd ${DIR}/build
wget https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tar.xz
tar xf Python-${VERSION}.tar.xz
cd Python-${VERSION}

echo "SSL=${OPENSSL}" >> Modules/Setup.dist
echo "_ssl _ssl.c \\" >> Modules/Setup.dist
echo "       -DUSE_SSL -I\$(SSL)/include -I\$(SSL)/include/openssl \\" >> Modules/Setup.dist
echo "       -L\$(SSL)/lib -lssl -lcrypto" >> Modules/Setup.dist

export CPPFLAGS=-I${OPENSSL}/include
export LDFLAGS=-L${OPENSSL}/lib
export LD_LIBRARY_PATH=${OPENSSL}/lib
./configure --prefix=${PREFIX} --enable-shared --enable-unicode=ucs4
make
make install

mv ${PREFIX}/bin/python ${PREFIX}/bin/python.bin
cp ${DIR}/python ${PREFIX}/bin/

cp -r ${OPENSSL}/lib/* ${PREFIX}/lib

export LD_LIBRARY_PATH=${PREFIX}/lib
ldd ${PREFIX}/lib/libpython2.7.so
ldd ${PREFIX}/bin/python.bin
#ldd ${PREFIX}/lib/python2.7/lib-dynload/_ssl.so

cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpthread.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libdl.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libutil.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libm.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libc.so* ${PREFIX}/lib

ldd ${PREFIX}/lib/libpython2.7.so
ldd ${PREFIX}/bin/python.bin

find ${PREFIX}/bin -type f -exec sed -i "s|#!${PREFIX}/|#!|g" {} \;
chmod +w ${PREFIX}/lib/libpython*
cd ${DIR}

find ${PREFIX} \( -name "*.pyc" -o -name "*.pyo" \) -exec rm {} \;
${PREFIX}/bin/python --version

${PREFIX}/bin/python -m ensurepip --upgrade
mv ${PREFIX}/bin/pip ${PREFIX}/bin/pip_runner
cp ${DIR}/pip ${PREFIX}/bin/
${PREFIX}/bin/pip install --upgrade setuptools pip
cp ${DIR}/pip ${PREFIX}/bin/
${PREFIX}/bin/pip

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}

# tests

${PREFIX}/bin/python -c 'from urllib2 import urlopen; print(urlopen("https://google.com"))'
${PREFIX}/bin/python -c 'import ssl; print(ssl.OPENSSL_VERSION)'

${PREFIX}/bin/pip install certbot
${PREFIX}/bin/certbot help
