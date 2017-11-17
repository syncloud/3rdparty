#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

NAME=phantomjs
VERSION=2.0
PREFIX=${DIR}/build/${NAME}

rm -rf ${DIR}/build
mkdir -p $PREFIX
cd ${DIR}/build

apt-get update
apt-get -y install build-essential g++ flex bison gperf ruby perl \
    libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev \
    libpng-dev libjpeg-dev python libx11-dev libxext-dev git

git clone git://github.com/ariya/phantomjs.git src
cd src
git checkout $VERSION
git submodule init
git submodule update

grep PHANTOMJS_VERSION src/consts.h
sed -i "s/PHANTOMJS_VERSION_MAJOR.*/PHANTOMJS_VERSION_MAJOR 1/g" src/consts.h
sed -i "s/PHANTOMJS_VERSION_MINOR.*/PHANTOMJS_VERSION_MINOR 9/g" src/consts.h
sed -i "s/PHANTOMJS_VERSION_PATCH.*/PHANTOMJS_VERSION_PATCH 20/g" src/consts.h
grep PHANTOMJS_VERSION src/consts.h
ls -la

#./build.sh --confirm
wget http://artifact.syncloud.org/3rdparty/phantomjs-$ARCH.tar.gz
tar xf phantomjs-$ARCH.tar.gz
cd phantomjs

cp -r $DIR/bin $PREFIX
cp -r bin/phantomjs $PREFIX/phantomjs.bin
ldd $PREFIX/bin/phantomjs.bin
mkdir $PREFIX/lib
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libicudata.so* $PREFIX/lib
cp	 /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl.so* $PREFIX/lib
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypto.so* $PREFIX/lib
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libfontconfig.so* $PREFIX/lib
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libfreetype.so* $PREFIX/lib
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libjpeg.so* $PREFIX/lib
cp /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpng12.so* $PREFIX/lib
cp /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libz.so* $PREFIX/lib
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libicui18n.so* $PREFIX/lib
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libicuuc.so* $PREFIX/lib
cp /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libexpat.so.1 

export LD_LIBRARY_PATH=${PREFIX}/lib
ldd $PREFIX/bin/phantomjs.bin

$PREFIX/bin/phantomjs --version
cd $DIR

tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
