#!/usr/bin/env bash

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

apt-get -y install build-essential \
    libxml2-dev autoconf libjpeg-dev libpng12-dev libfreetype6-dev \
    libzip-dev zlib1g-dev libcurl4-gnutls-dev dpkg-dev \
    libpq-dev libreadline-dev libldap2-dev libsasl2-dev libssl-dev libldb-dev \
    libtool

rm -rf build
mkdir -p build
cd build

wget http://www.imagemagick.org/download/releases/ImageMagick-${VERSION}.tar.xz
tar xJf ${NAME}-${VERSION}.tar.xz
cd ${NAME}-${VERSION}
./configure --prefix=${PREFIX}
make
make install

cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libfreetype.so* ${PREFIX}/lib

cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpng12.so* ${PREFIX}/lib

cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libjpeg.so* ${PREFIX}/lib

cd ${DIR}

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${ROOT} ${NAME}