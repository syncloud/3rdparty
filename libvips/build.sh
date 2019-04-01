#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1
LIB_ARCH=linux-armv6
if [[ ${ARCH} == "amd64" ]]; then
    LIB_ARCH=linux-x64
fi

NAME=libvips
VERSION=8.7.4
PREFIX=${DIR}/build/${NAME}

rm -rf ${DIR}/build
mkdir -p $PREFIX
cd ${DIR}/build

echo "building ${NAME}"

wget https://github.com/libvips/libvips/releases/download/v${VERSION}/vips-${VERSION}.tar.gz
tar xf vips-${VERSION}.tar.gz
cd vips-${VERSION}
./configure --prefix=${PREFIX}
make
make install

ls -la ${PREFIX}
ls -la ${PREFIX}/bin
ls -la ${PREFIX}/lib

cp /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libz.so* ${BUILD_DIR}/lib
cp /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpng12.so* ${BUILD_DIR}/lib
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libjpeg.so* ${BUILD_DIR}/lib
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgmodule-2.0.so* ${BUILD_DIR}/lib
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgobject-2.0.so* ${BUILD_DIR}/lib
cp /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libglib-2.0.so* ${BUILD_DIR}/lib
cp /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libexpat.so* ${BUILD_DIR}/lib
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libstdc++.so* ${BUILD_DIR}/lib
cp /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgcc_s.so* ${BUILD_DIR}/lib
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libffi.so* ${BUILD_DIR}/lib
cp /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpcre.so* ${BUILD_DIR}/lib

export LD_LIBRARY_PATH=${BUILD_DIR}/lib
ldd ${PREFIX}/lib/libvips.so
ldd ${PREFIX}/lib/libvips-cpp.so
cd ${DIR}

tar cpzf ${NAME}-${VERSION}-${LIB_ARCH}.tar.gz -C ${DIR}/build/${NAME} .
