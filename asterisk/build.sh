#!/bin/bash -ex

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
VERSION=13.10.0
BUILD=${DIR}/build
BASE_DIR=/opt/app/talk
PREFIX=${BASE_DIR}/${NAME}

apt-get -y install build-essential cmake libncurses5-dev libldap2-dev libsasl2-dev libssl-dev libldb-dev \
    uuid-dev libjansson-dev libxslt1-dev liburiparser1 libxml2 sqlite3 libsqlite3-dev libicu-dev \
    libsrtp0-dev libspeex1 libspeex-dev libspeexdsp1 libspeexdsp-dev libgsm1-dev autoconf debconf-utils

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
echo "libvpb0  libvpb0/countrycode  1" | debconf-set-selections
sed -i 's/apt-get install aptitude/apt-get -y install aptitude/g' ./contrib/scripts/install_prereq
sed -i 's/set -e/set -ex/g' ./contrib/scripts/install_prereq
cat ./contrib/scripts/install_prereq
./contrib/scripts/install_prereq install

echo "building asterisk"
./configure --help
./configure --prefix=${PREFIX} --with-pjproject-bundled --enable-dev-mode
make menuselect.makeopts
./menuselect/menuselect --enable TEST_FRAMEWORK menuselect.makeopts
make -j2
make install

echo "checking pjsip tools:"
ls -la third-party/pjproject/source/pjsip-apps/bin/
cp third-party/pjproject/source/pjsip-apps/bin/pjsua* ${PREFIX}/sbin/pjsua
cp third-party/pjproject/source/pjsip-apps/bin/pjsystest* ${PREFIX}/sbin/pjsystest
cp ${DIR}/bin/pjsua.sh ${PREFIX}/sbin/

${PREFIX}/sbin/pjsua.sh --help

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
if [ -f /usr/lib/libsrtp.so ]; then
    cp --remove-destination /usr/lib/libsrtp.so* ${PREFIX}/lib
fi
if [ -f /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsrtp.so ]; then
    cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsrtp.so* ${PREFIX}/lib
fi

cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgsm.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libspeex.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libspeexdsp.so* ${PREFIX}/lib

cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl*.so* ${PREFIX}/lib
# ubuntu hack
if [ -f /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl*.so* ]; then
  cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl*.so* ${PREFIX}/lib
fi

cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypto*.so* ${PREFIX}/lib
# ubuntu hack
if [ -f /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypto*.so* ]; then
    cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypto*.so* ${PREFIX}/lib
fi

rm -rf ${BUILD}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${BASE_DIR} ${NAME}
