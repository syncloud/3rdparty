#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

export TMPDIR=/tmp
export TMP=/tmp
NAME=postfix
VERSION=3.2.2
BUILD_DIR=./build
PREFIX=${DIR}/build/${NAME}
echo "building ${NAME}"

apt-get -y update
apt-get -y install build-essential libldap2-dev libsasl2-dev libssl-dev libldb-dev libdb-dev

rm -rf build
mkdir -p build
cd build

wget ftp://ftp.reverse.net/pub/postfix/official/${NAME}-${VERSION}.tar.gz --progress dot:giga
tar xf ${NAME}-${VERSION}.tar.gz
cd ${NAME}-${VERSION}

export CCARGS='-DDEF_CONFIG_DIR=\"/opt/app/mail/config/postfix\" \
	-DUSE_SASL_AUTH \
	-DDEF_SERVER_SASL_TYPE=\"dovecot\" \
  -I/usr/include -DHAS_LDAP \
  -DUSE_TLS'

export AUXLIBS="-L/usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE) \
  -lldap -L/usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE) \
  -llber -lssl -lcrypto"

make makefiles
make
make non-interactive-package install_root=${PREFIX}

mv ${PREFIX}/usr/sbin/postfix ${PREFIX}/usr/sbin/postfix.bin
cp ${DIR}/usr/sbin/* ${PREFIX}/usr/sbin

echo "original libs"
ldd ${PREFIX}/usr/sbin/postfix.bin
mkdir ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libldap*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/liblber*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypto.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libdb-5.3.so ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libnsl.so.1 ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libresolv.so.2 ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libdl.so.2 ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libc.so.6 ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsasl2.so.2 ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgnutls.so.30 ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpthread.so.0 ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libz.so.1 ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libp11-kit.so.0 ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libidn.so.11 ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libtasn1.so.6 ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libnettle.so.6 ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libhogweed.so.4 ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgmp.so.10 ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libffi.so.6 ${PREFIX}/lib


echo "embedded libs"
export LD_LIBRARY_PATH=${PREFIX}/lib
ldd ${PREFIX}/usr/sbin/postfix.bin

cd ../..

rm -rf ${NAME}-${ARCH}.tar.gz
tar czf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
