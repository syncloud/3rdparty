#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}


ARCH=$(uname -m)

export TMPDIR=/tmp
export TMP=/tmp
NAME=opendkim
VERSION=2.10.3
#VERSION=2-11-0-Beta2
BUILD=${DIR}/build
PREFIX=${BUILD}/${NAME}

apt update
apt-get -y install opendkim opendkim-tools


#export LD_LIBRARY_PATH=${PREFIX}/lib
#cp --remove-destination /lib/*/libbsd.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/*/libmilter*.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/*/libcrypt*.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/*/libssl*.so* ${PREFIX}/lib

mkdir -p $BUILD/$NAME
mkdir -p $BUILD/$NAME/bin
mkdir -p $BUILD/$NAME/sbin

cp /usr/sbin/opendkim $BUILD/$NAME/sbin
cp /usr/bin/convert_keylist $BUILD/$NAME/bin
cp /usr/bin/miltertest $BUILD/$NAME/bin
cp /usr/bin/opendkim-atpszone $BUILD/$NAME/bin
cp /usr/bin/opendkim-genkey $BUILD/$NAME/bin
cp /usr/bin/opendkim-genzone $BUILD/$NAME/bin
cp /usr/bin/opendkim-spam $BUILD/$NAME/bin
cp /usr/bin/opendkim-stats $BUILD/$NAME/bin
cp /usr/bin/opendkim-testkey $BUILD/$NAME/bin
cp /usr/bin/opendkim-testmsg $BUILD/$NAME/bin

ldd /usr/sbin/opendkim

/usr/sbin/opendkim --help || true
/usr/bin/opendkim-genkey --help || true

rm -rf ${BUILD}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}-${VERSION}.tar.gz -C ${BUILD} ${NAME}
