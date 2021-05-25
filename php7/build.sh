#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

ARCH=$(uname -m)

apt update
apt install -y libmagickwand-dev libonig-dev cmake libldb-dev libldap2-dev libsasl2-dev

export TMPDIR=/tmp
export TMP=/tmp
NAME=php7
VERSION=7.4.12
APCU_VERSION=5.1.20
APCU_BC_VERSION=1.0.5
IMAGE_MAGICK_VERSION=7.0.11-13
IMAGICK_VERSION=132a11f
SAMBA_VERSION=4.14.4
SMBCLIENT_VERSION=1.0.6

BUILD_DIR=${DIR}/build
PREFIX=${BUILD_DIR}/php

ln -s  /usr/include/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/curl  /usr/include/curl

rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
mkdir -p ${PREFIX}

cd ${BUILD_DIR}
wget https://download.samba.org/pub/samba/samba-${SAMBA_VERSION}.tar.gz -O samba.tar.gz --progress dot:giga
tar xf samba.tar.gz
cd samba-*
./bootstrap/generated-dists/debian10/bootstrap.sh
./configure --prefix=${PREFIX} --disable-python --without-ad-dc --bundled-libraries=ALL
make -j4
make install

cd ${BUILD_DIR}
wget https://github.com/ImageMagick/ImageMagick/archive/refs/tags/${IMAGE_MAGICK_VERSION}.tar.gz
tar xf ${IMAGE_MAGICK_VERSION}.tar.gz
cd ImageMagick-${IMAGE_MAGICK_VERSION}
./configure --prefix=${PREFIX}
make -j4
make install

cd ${BUILD_DIR}
wget https://libzip.org/download/libzip-1.7.1.tar.gz
tar xf libzip-1.7.1.tar.gz
cd libzip-1.7.1
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=${PREFIX}
make -j4
make install

cd ${BUILD_DIR}
wget http://php.net/get/php-${VERSION}.tar.bz2/from/this/mirror -O ${NAME}-${VERSION}.tar.bz2 --progress dot:giga
tar xjf ${NAME}-${VERSION}.tar.bz2
cd php-${VERSION}

wget https://pecl.php.net/get/apcu-${APCU_VERSION}.tgz --progress dot:giga
tar xzf apcu-${APCU_VERSION}.tgz -C ext/
mv ext/apcu-* ext/apcu

wget https://pecl.php.net/get/apcu_bc-${APCU_BC_VERSION}.tgz --progress dot:giga
tar xzf apcu_bc-${APCU_BC_VERSION}.tgz -C ext/
mv ext/apcu_bc-* ext/apcu_bc

wget https://pecl.php.net/get/smbclient-${SMBCLIENT_VERSION}.tgz --progress dot:giga
tar xf smbclient-${SMBCLIENT_VERSION}.tgz -C ext/
mv ext/smbclient-* ext/smbclient

rm configure
./buildconf --force

if [ "$ARCH" == "armv7l"  ]; then
    OPTIONS="-D_FILE_OFFSET_BITS=64"
fi

./configure --help
export LD_LIBRARY_PATH=${PREFIX}/lib
#export CPPFLAGS=-I${PREFIX}/include
#export LDFLAGS="-L${PREFIX}/lib"
export PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig
export LIBZIP_CFLAGS=-I${PREFIX}/include
export LIBZIP_LIBS="-L${PREFIX}/lib -lzip"

pkg-config --modversion libzip
pkg-config --cflags libzip
pkg-config --libs libzip

CFLAGS="$OPTIONS" ./configure \
    --enable-fpm \
    --with-mysqli \
    --with-pgsql \
    --with-pdo-pgsql \
    --enable-opcache \
    --prefix ${PREFIX} \
    --with-config-file-path=${BUILD_DIR}/config \
    --enable-gd \
    --with-freetype \
    --with-zip \
    --with-zlib \
    --with-curl \
    --with-readline \
    --enable-mbstring \
    --enable-apcu \
    --with-libdir=lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE) \
    --with-jpeg \
    --with-ldap \
    --with-ldap-sasl \
    --with-openssl \
    --enable-intl \
    --enable-exif \
    --enable-pcntl \
    --enable-ftp \
    --enable-bcmath \
    --with-gmp

make -j3
make install

cd ${PREFIX}/bin
rm phar
ln -s phar.phar phar

LD=$(readlink -f /lib*/ld-linux-*)
cp --remove-destination $LD ${PREFIX}/lib/ld.so
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpng*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libjpeg.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpng*.so ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libnettle.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libldap*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/liblber*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgssapi*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libkrb5*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsqlite3*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypt*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libffi*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsasl2*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgnutls*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libhogweed*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libltdl.so* ${PREFIX}/lib

cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libhistory.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcurl.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libncurses.so* ${PREFIX}/lib

cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpthread.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypt.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libz.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libresolv.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libreadline.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libtinfo.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpq.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/librt.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libstdc++.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libm.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libdl.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libnsl.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libxml2.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libicui18n.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libicuuc.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libicudata.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libicuio.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgcc_s.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libc.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/liblzma.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libidn.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/librtmp.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssh2.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libk5crypto.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcom_err.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libkeyutils.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libp11-kit.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libtasn1.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgmp.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgcrypt.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgpg-error.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libfreetype.so* ${PREFIX}/lib

#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsmbclient.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsamba-util.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsmbconf.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libndr.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libndr-standard.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libbsd.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libtalloc.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgensec.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libtevent.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libtevent-util.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libndr-nbt.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsamba-hostconfig.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsamba-credentials.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libdcerpc-binding.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libtdb.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcap.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libldb.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libwbclient.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsamdb.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libntdb.so* ${PREFIX}/lib
#cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libattr.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libndr-krb5pac.so* ${PREFIX}/lib
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/samba/*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libMagickCore*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libMagickWand*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgomp.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/liblcms2.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/liblqr-1.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libfftw3.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libfontconfig.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libX11.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libXext.so.* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libbz2.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libxcb.so.* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libexpat.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libXau.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libXdmcp.so.* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpcre.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libonig.so.* ${PREFIX}/lib

cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libldap_r-*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypto.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgssapi_krb5.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libnghttp2.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libidn2.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpsl.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsystemd.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libunwind*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libunistring.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libglib-*.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libuuid.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/liblz4.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libjansson.so* ${PREFIX}/lib

find ${PREFIX}/lib/php/extensions -name "*.so*" -exec mv {} ${PREFIX}/lib/php/extensions \;

ldd ${PREFIX}/sbin/php-fpm

wget --progress dot:giga https://github.com/Imagick/imagick/archive/refs/heads/${IMAGICK_VERSION}.tar.gz -O imagick.tar.gz
tar xzf imagick.tar.gz
cd imagick-*
export PATH=$PATH:${PREFIX}/bin
phpize
./configure --prefix=${PREFIX}
make
make install

cd ${DIR}

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${BUILD_DIR} php
