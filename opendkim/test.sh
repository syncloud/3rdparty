#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

export LD_LIBRARY_PATH=${DIR}/build/opendkim/lib
ldd ${DIR}/build/opendkim/sbin/opendkim

${DIR}/build/opendkim/sbin/opendkim --help || true
${DIR}/build/opendkim/sbin/opendkim-genkey --help || true
ib/*/libcrypt*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/*/libssl*.so* ${PREFIX}/lib

ldd ${DIR}/build/opendkim/sbin/opendkim

${PREFIX}/sbin/opendkim --help || true
${PREFIX}/sbin/opendkim-genkey --help || true

PREFIX}/sbin/opendkim

${PREFIX}/sbin/opendkim --help || true
${PREFIX}/sbin/opendkim-genkey --help || true

H=${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libbsd.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libmilter*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypt*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl*.so* ${PREFIX}/lib

ldd ${PREFIX}/sbin/opendkim

${PREFIX}/sbin/opendkim --help || true
${PREFIX}/sbin/opendkim-genkey --help || true

rm -rf ${BUILD}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}-${VERSION}.tar.gz -C ${BUILD} ${NAME}

tar czf ${DIR}/${NAME}-${ARCH}-${VERSION}.tar.gz -C ${BUILD} ${NAME}
