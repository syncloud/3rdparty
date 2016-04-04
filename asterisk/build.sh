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
NAME=asterisk
VERSION=13.8.0
BUILD=${DIR}/build
BASE_DIR=/opt/app/talk
PREFIX=${BASE_DIR}/${NAME}

apt-get -y install build-essential cmake libncurses5-dev libldap2-dev libsasl2-dev libssl-dev libldb-dev \
    uuid-dev libjansson-dev libxslt1-dev liburiparser1 libxml2 sqlite3 libsqlite3-dev libicu-dev libcurl3-gnutls \
    libsrtp0-dev libspeex1 libspeex-dev libspeexdsp1 libspeexdsp-dev libgsm1-dev portaudio19-dev autoconf

rm -rf ${PREFIX}
mkdir -p ${PREFIX}
rm -rf ${BUILD}
mkdir ${BUILD}
cd ${BUILD}

wget http://downloads.asterisk.org/pub/telephony/${NAME}/releases/${NAME}-${VERSION}.tar.gz \
    --progress dot:giga
tar xzf ${NAME}-${VERSION}.tar.gz
cd ${NAME}-${VERSION}

echo "building pjproject"
./contrib/scripts/install_prereq install

echo "building asterisk"
./configure --help
./configure --prefix=${PREFIX} --with-pjproject-bundled
make
make install

cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libjansson.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libxslt.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libexslt.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libuuid.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libuuid.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/liburiparser.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libxml2.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsqlite3.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libicu*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcurl-gnutls.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcurl-gnutls.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/libsrtp.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgsm.so* ${PREFIX}/lib


rm -rf ${BUILD}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${BASE_DIR} ${NAME}
