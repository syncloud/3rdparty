#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

ARCH=$(uname -m)
NAME=openldap
VERSION=2.4.57
BUILD_DIR=${DIR}/build
PREFIX=${BUILD_DIR}/${NAME}

echo "building ${NAME}"
apt update
apt -y install build-essential flex bison libreadline-dev zlib1g-dev libpcre3-dev libdb5.3-dev libsasl2-dev groff

rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

wget http://www.openldap.org/software/download/OpenLDAP/openldap-release/${NAME}-${VERSION}.tgz --progress dot:giga
tar xzf ${NAME}-${VERSION}.tgz
cd ${NAME}-${VERSION}
./configure --help
./configure --prefix=${PREFIX} --enable-overlays
make -j2
make install
mkdir ${PREFIX}/slapd.d
find ${PREFIX} -name "*ppolicy*"
cp ${DIR}/slapadd.sh ${PREFIX}/sbin/
cp ${DIR}/ldapadd.sh ${PREFIX}/bin/

cp /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libuuid.so* ${PREFIX}/lib/
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libdb-5.3.so ${PREFIX}/lib/
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libicuuc.so* ${PREFIX}/lib/
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libicudata.so* ${PREFIX}/lib/
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsasl2.so* ${PREFIX}/lib/
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl.so* ${PREFIX}/lib/
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypto.so* ${PREFIX}/lib/
#cp /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libresolv.so* ${PREFIX}/lib/
#cp /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpthread.so* ${PREFIX}/lib/
#cp /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libc.so* ${PREFIX}/lib/
#cp /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libdl.so* ${PREFIX}/lib/

cd ${DIR}
rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${BUILD_DIR} ${NAME}
