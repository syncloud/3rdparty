#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

apt install -y libsmbclient-dev

export TMPDIR=/tmp
export TMP=/tmp
NAME=php7
VERSION=7.1.21
APCU_VERSION=5.1.3
APCU_BC_VERSION=1.0.2
#IMAGICK_VERSION=3.1.2
#IMAGICK_VERSION=3.3.0RC2
IMAGICK_VERSION=3.2.0RC1
IMAGEMAGICK_VERSION=6.9.2-1
SMBCLIENT_VERSION=0.9.0

ROOT=${DIR}/build/install
PREFIX=${ROOT}/${NAME}

echo "building ${NAME}"

ln -s  /usr/include/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/curl  /usr/include/curl

rm -rf build
mkdir -p build
cd build

#wget -O ImageMagick-${ARCH}.tar.gz http://build.syncloud.org:8111/guestAuth/repository/download/thirdparty_ImageMagick_${ARCH}/lastSuccessful/ImageMagick-${ARCH}.tar.gz --progress dot:giga

#tar xzf ImageMagick-${ARCH}.tar.gz

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

#wget https://pecl.php.net/get/imagick-${IMAGICK_VERSION}.tgz --progress dot:giga
#tar xzf imagick-${IMAGICK_VERSION}.tgz -C ext/
#mv ext/imagick-* ext/imagick

rm configure
./buildconf --force

#sed -i -e 's~^\([[:space:]]*\)\(if test -f \$LDAP_LIBDIR/liblber\.a || test -f \$LDAP_LIBDIR/liblber\.\$SHLIB_SUFFIX_NAME; then\)$~\1if test -f \$LDAP_LIBDIR/x86_64-linux-gnu/liblber\.a || test -f \$LDAP_LIBDIR/x86_64-linux-gnu/liblber\.\$SHLIB_SUFFIX_NAME; then\n\1  LDAP_LIBDIR=$LDAP_LIBDIR/x86_64-linux-gnu\n\1fi\n\n\1\2~' configure;
#IMAGE_MAGICK_PATH=${DIR}/build/ImageMagick
#export PKG_CONFIG_PATH=${IMAGE_MAGICK_PATH}/lib/pkgconfig
if [ "$ARCH" == "armv7l"  ]; then
    OPTIONS="-D_FILE_OFFSET_BITS=64"
fi

./configure --help

export CPPFLAGS=-I/usr/include/samba-4.0

CFLAGS="$OPTIONS" ./configure \
    --enable-fpm \
    --with-pgsql \
    --with-pdo-pgsql \
    --enable-opcache \
    --prefix ${PREFIX} \
    --with-config-file-path=${ROOT}/config \
    --with-gd \
    --enable-gd-native-ttf \
    --with-freetype-dir=/usr/include/freetype2 \
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
    --with-ldap-sasl \
    --with-openssl \
    --with-mcrypt \
    --enable-intl \
    --enable-exif \
    --enable-pcntl \
    --enable-ftp
#    --with-imagick \

make -j2
rm -rf ${PREFIX}
make install

cd ${PREFIX}/bin
rm phar
ln -s phar.phar phar

ldd ${PREFIX}/sbin/php-fpm

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
#cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libreadline.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libhistory.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcurl.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libncurses.so* ${PREFIX}/lib

#cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpthread.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypt.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libz.so* ${PREFIX}/lib
#cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libresolv.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libreadline.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libtinfo.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpq.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/librt.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libstdc++.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libm.so* ${PREFIX}/lib
#cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libdl.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libnsl.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libxml2.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libicui18n.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libicuuc.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libicudata.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libicuio.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgcc_s.so* ${PREFIX}/lib
#cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libc.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/liblzma.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libidn.so* ${PREFIX}/lib
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

cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsmbclient.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsamba-util.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsmbconf.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libndr.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libndr-standard.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libbsd.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libtalloc.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgensec.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libtevent.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libtevent-util.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libndr-nbt.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsamba-hostconfig.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsamba-credentials.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libdcerpc-binding.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libtdb.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcap.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libldb.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libwbclient.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsamdb.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libntdb.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libattr.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libndr-krb5pac.so* ${PREFIX}/lib

cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/samba/*.so* ${PREFIX}/lib

cp --remove-destination /usr/lib/libmcrypt.so* ${PREFIX}/lib

echo "test references"

export LD_LIBRARY_PATH=${PREFIX}/lib
ldd ${PREFIX}/sbin/php-fpm

find ${PREFIX}/lib/php/extensions -name "*.so*" -exec mv {} ${PREFIX}/lib/php/extensions \;

find ${DIR} -name "*.so"

${PREFIX}/bin/php -i

cd ${DIR}

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${ROOT} ${NAME}
