#!/bin/bash -xe

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
VERSION=2.4.47
BUILD_DIR=${DIR}/build
PREFIX=${BUILD_DIR}/${NAME}

echo "building ${NAME}"

apt-get -y install build-essential flex bison libreadline-dev zlib1g-dev libpcre3-dev libdb5.3-dev libsasl2-dev groff

rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

wget http://www.openldap.org/software/download/OpenLDAP/openldap-release/${NAME}-${VERSION}.tgz --progress dot:giga
tar xzf ${NAME}-${VERSION}.tgz
cd ${NAME}-${VERSION}
./configure --help
./configure --prefix=${PREFIX} --enable-modules --enable-overlays=mod
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

${PREFIX}/sbin/slapadd.sh --help || true
${PREFIX}/bin/ldapadd.sh --help || true

export LD_LIBRARY_PATH=${PREFIX}/lib
mkdir ${BUILD_DIR}/slapd.d
sed -i "s#@ETC_DIR@#${PREFIX}/etc/openldap#g" ${DIR}/slapd.test.init.ldif
sed -i "s#@LIB_DIR@#${PREFIX}/lib/openldap#g" ${DIR}/slapd.test.init.ldif
${PREFIX}/sbin/slapadd.sh -F ${BUILD_DIR}/slapd.d -b "cn=config" -l ${DIR}/slapd.test.init.ldif

SOCKET=${BUILD_DIR}/ldap.socket
${PREFIX}/libexec/slapd -h "ldapi://${SOCKET//\//%2F}" -F ${BUILD_DIR}/slapd.d

cd ${DIR}
rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${BUILD_DIR} ${NAME}
