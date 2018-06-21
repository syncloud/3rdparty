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
NAME=postfix
VERSION=3.2.2
BUILD_DIR=${DIR}/build
PREFIX=${BUILD_DIR}/${NAME}
echo "building ${NAME}"

apt remove -y libsasl2-dev libsasl2

rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}

cd ${BUILD_DIR}
wget ftp://ftp.cyrusimap.org/cyrus-sasl/cyrus-sasl-2.1.26.tar.gz
tar xf cyrus-sasl-2.1.26.tar.gz
cd cyrus-sasl-2.1.26
./configure --help
./configure --prefix=${BUILD_DIR}/sasl --enable-login --enable-ntlm
make
make install

cd ${BUILD_DIR}
wget ftp://ftp.reverse.net/pub/postfix/official/${NAME}-${VERSION}.tar.gz --progress dot:giga
tar xf ${NAME}-${VERSION}.tar.gz
cd ${NAME}-${VERSION}
#TODO: It is impossible to override paths at runtime
export CCARGS='-DDEF_CONFIG_DIR=\"/opt/data/mail/config/postfix\" \
	-DUSE_SASL_AUTH \
	-DDEF_SERVER_SASL_TYPE=\"dovecot\" -I/usr/include \
	-DUSE_CYRUS_SASL -I'${BUILD_DIR}'/sasl/include/sasl \
 -DHAS_LDAP \
 -DUSE_TLS'

export AUXLIBS="-L/usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE) \
  -lldap -L/usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE) \
  -L${BUILD_DIR}/sasl/lib
  -llber -lssl -lcrypto -lsasl2"

make makefiles
make
make non-interactive-package install_root=${PREFIX}

mv ${PREFIX}/usr/sbin/postfix ${PREFIX}/usr/sbin/postfix.bin
cp ${DIR}/usr/sbin/* ${PREFIX}/usr/sbin

echo "original libs"
ldd ${PREFIX}/usr/sbin/postfix.bin
mkdir ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libldap*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/liblber*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypto.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libdb-*.so ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libnsl.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libresolv.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libdl.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libc.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsasl2.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgnutls-deb0.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpthread.so.0 ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libz.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libp11-kit.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libtasn1.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libnettle.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libhogweed.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgmp.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libffi.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libicui18n.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libicuuc.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libicudata.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libncurses.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpcre.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libstdc++.so.* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libm.so.* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgcc_s.so.* ${PREFIX}/lib

echo "embedded libs"
#export LD_DEBUG=libs
export LD_LIBRARY_PATH=${PREFIX}/lib
export LD_PRELOAD=${PREFIX}/lib
ldd ${PREFIX}/usr/sbin/postfix.bin

${PREFIX}/usr/sbin/postconf -a

rm -rf ${DIR}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${BUILD_DIR} ${NAME}
