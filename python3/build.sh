#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

VERSION=3.9.2
OPENSSL_VERSION=1.1.1h
SQLITE_VERSION=autoconf-3310100

NAME=python3
PREFIX=${DIR}/build/${NAME}

apt-get -y install build-essential flex bison libreadline-dev zlib1g-dev libpcre3-dev libbz2-dev libsqlite3-dev unzip libffi-dev

rm -rf build
mkdir build

cd ${DIR}/build
curl -O https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
tar xf openssl-${OPENSSL_VERSION}.tar.gz
cd openssl-${OPENSSL_VERSION}
./config --prefix=${PREFIX} --openssldir=/usr/lib/ssl no-shared no-ssl2 no-ssl3 -fPIC
make
make install

cd ${DIR}/build
rm -rf /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsqlite3.so*
wget https://www.sqlite.org/2020/sqlite-${SQLITE_VERSION}.tar.gz
tar -zxvf sqlite-${SQLITE_VERSION}.tar.gz
cd sqlite-${SQLITE_VERSION}
./configure --prefix=${PREFIX}
make
make install

cd ${DIR}/build
wget https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tar.xz
tar xf Python-${VERSION}.tar.xz
cd Python-${VERSION}

echo "SSL=${PREFIX}" >> Modules/Setup.dist
echo "_ssl _ssl.c \\" >> Modules/Setup.dist
echo "       -DUSE_SSL -I\$(SSL)/include -I\$(SSL)/include/openssl \\" >> Modules/Setup.dist
echo "       -L\$(SSL)/lib -lssl -lcrypto" >> Modules/Setup.dist

export CPPFLAGS=-I${PREFIX}/include
export LDFLAGS=-L${PREFIX}/lib
export LD_LIBRARY_PATH=${PREFIX}/lib
./configure --prefix=${PREFIX} --enable-shared --enable-unicode=ucs4
make
make install

cp ${DIR}/python ${PREFIX}/bin/

ldd ${PREFIX}/lib/libpython3.so
ldd ${PREFIX}/bin/python3
#ldd ${PREFIX}/lib/python3.7/lib-dynload/_ssl.so

#cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpthread.so* ${PREFIX}/lib
#cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libdl.so* ${PREFIX}/lib
#cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libutil.so* ${PREFIX}/lib
#cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libm.so* ${PREFIX}/lib
#cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libc.so* ${PREFIX}/lib

ldd ${PREFIX}/lib/libpython3.so
ldd ${PREFIX}/bin/python3

cp ${DIR}/py.test.sh ${PREFIX}/bin/

${PREFIX}/bin/python -m ensurepip --upgrade
cp ${DIR}/pip ${PREFIX}/bin/

${PREFIX}/bin/pip install --upgrade setuptools pip
mv ${PREFIX}/bin/pip ${PREFIX}/bin/pip_runner
cp ${DIR}/pip ${PREFIX}/bin/

${PREFIX}/bin/pip

find ${PREFIX}/bin -type f -exec sed -i "s|#!${PREFIX}/|#!|g" {} \;
chmod +w ${PREFIX}/lib/libpython*
cd ${DIR}

find ${PREFIX} \( -name "*.pyc" -o -name "*.pyo" \) -exec rm {} \;
${PREFIX}/bin/python --version

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}

# tests

${PREFIX}/bin/python -c 'import urllib.request; print(urllib.request.urlopen("https://google.com"))'
${PREFIX}/bin/python -c 'import ssl; print(ssl.OPENSSL_VERSION)'

#${PREFIX}/bin/pip install cryptography==2.0
${PREFIX}/bin/pip install certbot
${PREFIX}/bin/certbot help
${PREFIX}/bin/pip install pytest
${PREFIX}/bin/py.test.sh --help
