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
NAME=php
VERSION=5.6.13
#VERSION=5.6.9
APCU_VERSION=4.0.7
#IMAGICK_VERSION=3.1.2
#IMAGICK_VERSION=3.3.0RC2
IMAGICK_VERSION=3.2.0RC1
IMAGEMAGICK_VERSION=6.9.2-1
ROOT=${DIR}/build/install
PREFIX=${ROOT}/${NAME}

echo "building ${NAME}"

apt-get -y install build-essential \
    libxml2-dev autoconf libjpeg-dev libpng12-dev libfreetype6-dev \
    libzip2 libzip-dev zlib1g-dev libcurl4-gnutls-dev dpkg-dev \
    libpq-dev libreadline-dev libldap2-dev libsasl2-dev libssl-dev libldb-dev \
    p7zip libtool
#    libmagickwand-6.q16-dev

rm -rf build
mkdir -p build
cd build

#wget -O ImageMagick-${ARCH}.tar.gz http://build.syncloud.org:8111/guestAuth/repository/download/thirdparty_ImageMagick_${ARCH}/lastSuccessful/ImageMagick-${ARCH}.tar.gz --progress dot:giga

#tar xzf ImageMagick-${ARCH}.tar.gz

wget http://php.net/get/${NAME}-${VERSION}.tar.bz2/from/this/mirror -O ${NAME}-${VERSION}.tar.bz2 --progress dot:giga
tar xjf ${NAME}-${VERSION}.tar.bz2
cd ${NAME}-${VERSION}

wget https://pecl.php.net/get/apcu-${APCU_VERSION}.tgz --progress dot:giga
tar xzf apcu-${APCU_VERSION}.tgz -C ext/
mv ext/apcu-* ext/apcu

#wget https://pecl.php.net/get/imagick-${IMAGICK_VERSION}.tgz --progress dot:giga
#tar xzf imagick-${IMAGICK_VERSION}.tgz -C ext/
#mv ext/imagick-* ext/imagick

rm configure
./buildconf --force

#sed -i -e 's~^\([[:space:]]*\)\(if test -f \$LDAP_LIBDIR/liblber\.a || test -f \$LDAP_LIBDIR/liblber\.\$SHLIB_SUFFIX_NAME; then\)$~\1if test -f \$LDAP_LIBDIR/x86_64-linux-gnu/liblber\.a || test -f \$LDAP_LIBDIR/x86_64-linux-gnu/liblber\.\$SHLIB_SUFFIX_NAME; then\n\1  LDAP_LIBDIR=$LDAP_LIBDIR/x86_64-linux-gnu\n\1fi\n\n\1\2~' configure;
#IMAGE_MAGICK_PATH=${DIR}/build/ImageMagick
#export PKG_CONFIG_PATH=${IMAGE_MAGICK_PATH}/lib/pkgconfig

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
    --enable-mbstring \
    --enable-apcu \
    --with-libdir=lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE) \
    --with-jpeg-dir \
    --with-png-dir \
    --with-ldap \
    --with-ldap-sasl
#    --with-imagick \

make -j2
rm -rf ${PREFIX}
make install

cd ${PREFIX}/bin
rm phar
ln -s phar.phar phar

cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpng12.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcurl-gnutls.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libjpeg.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpng.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libnettle.so* ${PREFIX}/lib

echo "test references"

export LD_LIBRARY_PATH=${PREFIX}/lib
ldd ${PREFIX}/sbin/php-fpm

cd ${DIR}

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${ROOT} ${NAME}
