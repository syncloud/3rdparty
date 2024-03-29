#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

ARCH=$(uname -m)

export TMPDIR=/tmp
export TMP=/tmp
NAME=dovecot
VERSION=2.3.16
#TODO: It is impossible to override paths at runtime
BUILD_DIR=/snap/mail/current
PREFIX=${BUILD_DIR}/${NAME}

apt-get update
apt-get -y install build-essential libncurses5-dev libldap2-dev libsasl2-dev libssl-dev libldb-dev wget

rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

wget http://www.dovecot.org/releases/2.3/${NAME}-${VERSION}.tar.gz \
    --progress dot:giga
tar xzf ${NAME}-${VERSION}.tar.gz
cd ${NAME}-${VERSION}

./configure --help
./configure --prefix=${PREFIX} \
    --with-rawlog \
    --with-ldap \
    --disable-rpath

make -j4
make install

echo "original libs"
ldd ${PREFIX}/sbin/dovecot

cp --remove-destination /usr/lib/*/libssl*.so* ${PREFIX}/lib/dovecot
cp --remove-destination /lib/*/libcrypt.so* ${PREFIX}/lib/dovecot
cp --remove-destination /usr/lib/*/libcrypto.so* ${PREFIX}/lib/dovecot
cp --remove-destination /lib/*/libdl.so* ${PREFIX}/lib
cp --remove-destination /lib/*/libc.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/*/libldap_r*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/*/liblber-2.4.so* ${PREFIX}/lib
cp --remove-destination /lib/*/libresolv.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/*/libsasl2.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/*/libgnutls.so* ${PREFIX}/lib
cp --remove-destination /lib/*/libpthread.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/*/libp11-kit.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/*/libidn2.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/*/libunistring.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/*/libtasn1.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/*/libnettle.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/*/libhogweed.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/*/libgmp.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/*/libffi.so* ${PREFIX}/lib

cp $(readlink -f /lib*/ld-linux-*.so*) ${PREFIX}/lib/ld.so

echo "embedded libs"
export LD_LIBRARY_PATH=${PREFIX}/lib
ldd ${PREFIX}/sbin/dovecot
ldd ${PREFIX}/libexec/dovecot/auth

mkdir $DIR/build
mv $PREFIX $DIR/build
cp $DIR/dovecot.sh $DIR/build/dovecot/bin
cp $DIR/doveadm.sh $DIR/build/dovecot/bin
cp $DIR/auth.sh $DIR/build/dovecot/libexec/dovecot

rm -rf ${DIR}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C $DIR/build ${NAME}
