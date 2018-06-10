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
NAME=ImageMagick
VERSION=6.9.2-10
ROOT=${DIR}/build
PREFIX=${ROOT}/${NAME}

echo "building ${NAME}"

rm -rf build
mkdir -p build
cd build

#wget http://www.imagemagick.org/download/releases/ImageMagick-${VERSION}.tar.xz
wget http://mirror.checkdomain.de/imagemagick/releases/ImageMagick-${VERSION}.tar.xz
tar xJf ${NAME}-${VERSION}.tar.xz
cd ${NAME}-${VERSION}
./configure --prefix=${PREFIX}
make
make install

ls -ls ${PREFIX}/lib

cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libfreetype.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpng12.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libjpeg.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgomp.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/liblcms2.so* ${PREFIX}/lib

cd ${DIR}

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${ROOT} ${NAME}