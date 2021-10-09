#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

ARCH=$(uname -m)

export TMPDIR=/tmp
export TMP=/tmp
NAME=dovecot
VERSION=2.2.27
#TODO: It is impossible to override paths at runtime
BUILD_DIR=/snap/mail/current
PREFIX=${BUILD_DIR}/${NAME}

apt-get -y install build-essential cmake libncurses5-dev libldap2-dev libsasl2-dev libssl-dev libldb-dev

rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

wget http://www.dovecot.org/releases/2.2/${NAME}-${VERSION}.tar.gz \
    --progress dot:giga
tar xzf ${NAME}-${VERSION}.tar.gz
cd ${NAME}-${VERSION}

./configure --help
./configure --prefix=${PREFIX} \
    --with-rawlog \
    --with-ldap \
    --disable-rpath

make
make install

echo "original libs"
ldd ${PREFIX}/sbin/dovecot

cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl*.so* ${PREFIX}/lib/dovecot
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypt.so* ${PREFIX}/lib/dovecot
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypto.so* ${PREFIX}/lib/dovecot
#cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libdl.so* ${PREFIX}/lib/dovecot
#cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libc.so* ${PREFIX}/lib/dovecot

echo "embedded libs"
export LD_LIBRARY_PATH=${PREFIX}/lib
ldd ${PREFIX}/sbin/dovecot

rm -rf ${DIR}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${BUILD_DIR} ${NAME}
