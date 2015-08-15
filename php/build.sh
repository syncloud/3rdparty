#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

apt-get -y install dpkg-dev
ARCH=$(dpkg-architecture -qDEB_HOST_GNU_CPU)

export TMPDIR=/tmp
export TMP=/tmp
NAME=php
VERSION=5.6.9
ROOT=${DIR}/build/install
PREFIX=${ROOT}/${NAME}

echo "building ${NAME}"

apt-get -y install build-essential \
    libxml2-dev autoconf libjpeg-dev libpng12-dev libfreetype6-dev \
    libzip2 libzip-dev zlib1g-dev libcurl4-gnutls-dev dpkg-dev \
    libpq-dev libreadline-dev libldap2-dev libsasl2-dev libssl-dev libldb-dev

rm -rf build
mkdir -p build
cd build

wget http://php.net/get/${NAME}-${VERSION}.tar.bz2/from/this/mirror -O ${NAME}-${VERSION}.tar.bz2 --progress dot:giga
tar xjf ${NAME}-${VERSION}.tar.bz2
cd ${NAME}-${VERSION}

./configure \
    --enable-fpm \
    --with-pgsql \
    --with-pdo-pgsql \
    --enable-opcache \
    --prefix ${PREFIX} \
    --with-config-file-path=${ROOT}/config \
    --with-gd \
    --enable-zip \
    --with-zlib \
    --with-curl \
    --with-readline \
    --with-ldap \
    --with-ldap-sasl \
    --with-libdir=lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE) \
    --enable-mbstring
make -j2
rm -rf ${PREFIX}
make install

cd ${PREFIX}/bin
rm phar
ln -s phar.phar phar


cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpng12.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcurl-gnutls.so* ${PREFIX}/lib

cd ${DIR}

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${ROOT} ${NAME}