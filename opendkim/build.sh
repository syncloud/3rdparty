#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}


ARCH=$(uname -m)

export TMPDIR=/tmp
export TMP=/tmp
NAME=opendkim
BUILD=${DIR}/build
PREFIX=${BUILD}/${NAME}

mkdir -p $PREFIX
mkdir -p $PREFIX/bin
mkdir -p $PREFIX/sbin
mkdir -p $PREFIX/lib

apt update
apt-get -y install opendkim opendkim-tools

cp $(readlink -f /lib*/ld-linux-*.so*) ${PREFIX}/lib/ld.so

cp /usr/lib/libopendkim.so.11 ${PREFIX}/lib
cp /usr/lib/*/libmilter.so.1.0.1 ${PREFIX}/lib
cp /usr/lib/*/libssl.so.1.1 ${PREFIX}/lib
cp /usr/lib/*/libcrypto.so.1.1 ${PREFIX}/lib
cp /lib/*/libresolv.so.2 ${PREFIX}/lib
cp /usr/lib/*/libdb-5.3.so ${PREFIX}/lib
cp /usr/lib/libopendbx.so.1 ${PREFIX}/lib
cp /lib/*/libdl.so.2 ${PREFIX}/lib
cp /usr/lib/*/libmemcached.so.11 ${PREFIX}/lib
cp /usr/lib/*/libmemcachedutil.so.2 ${PREFIX}/lib
cp /usr/lib/*/liblua5.1.so.0 ${PREFIX}/lib
cp /usr/lib/*/libldap_r-2.4.so.2 ${PREFIX}/lib
cp /usr/lib/*/liblber-2.4.so.2 ${PREFIX}/lib
cp /usr/lib/*/libunbound.so.8 ${PREFIX}/lib
cp /usr/lib/libvbr.so.2 ${PREFIX}/lib
cp /usr/lib/librbl.so.1 ${PREFIX}/lib
cp /usr/lib/*/libbsd.so.0 ${PREFIX}/lib
cp /lib/*/libpthread.so.0 ${PREFIX}/lib
cp /lib/*/libc.so.6 ${PREFIX}/lib
cp /usr/lib/*/libsasl2.so.2 ${PREFIX}/lib
cp /usr/lib/*/libstdc++.so.6 ${PREFIX}/lib
cp /lib/*/libm.so.6 ${PREFIX}/lib
cp /lib/*/libgcc_s.so.1 ${PREFIX}/lib
cp /usr/lib/*/libgnutls.so.30 ${PREFIX}/lib
cp /usr/lib/*/libevent-2.1.so.6 ${PREFIX}/lib
cp /usr/lib/*/libhogweed.so.4 ${PREFIX}/lib
cp /usr/lib/*/libnettle.so.6 ${PREFIX}/lib
cp /usr/lib/*/libgmp.so.10 ${PREFIX}/lib
cp /lib/*/librt.so.1 ${PREFIX}/lib
cp /usr/lib/*/libp11-kit.so.0 ${PREFIX}/lib
cp /usr/lib/*/libidn2.so.0 ${PREFIX}/lib
cp /usr/lib/*/libunistring.so.2 ${PREFIX}/lib
cp /usr/lib/*/libtasn1.so.6 ${PREFIX}/lib
cp /usr/lib/*/libffi.so.6 ${PREFIX}/lib

cp /usr/sbin/opendkim $PREFIX/sbin
cp /usr/bin/convert_keylist $PREFIX/bin
cp /usr/bin/miltertest $PREFIX/bin
cp /usr/bin/opendkim-atpszone $PREFIX/bin
cp /usr/bin/opendkim-genkey $PREFIX/bin
cp /usr/bin/opendkim-genzone $PREFIX/bin
cp /usr/bin/opendkim-spam $PREFIX/bin
cp /usr/bin/opendkim-stats $PREFIX/bin
cp /usr/bin/opendkim-testkey $PREFIX/bin
cp /usr/bin/opendkim-testmsg $PREFIX/bin

cp $DIR/bin/* $PREFIX/bin

export LD_LIBRARY_PATH=${PREFIX}/lib
ldd $PREFIX/sbin/opendkim
$PREFIX/sbin/opendkim -V
ldd $PREFIX/bin/opendkim-genkey
$PREFIX/bin/opendkim-genkey --help

rm -rf ${BUILD}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}-${VERSION}.tar.gz -C ${BUILD} ${NAME}
