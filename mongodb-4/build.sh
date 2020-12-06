#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1
MONGO_ARCH=armv7l
if [[ ${ARCH} == "amd64" ]]; then
    MONGO_ARCH=x86_64
fi

NAME=mongodb-4
VERSION=4.0.21
GCC_VERSION=5
PREFIX=${DIR}/build/${NAME}

rm -rf ${DIR}/build
mkdir -p $PREFIX

apt update
apt remove -y gcc cpp

cd ${DIR}/build
wget --progress=dot:giga https://github.com/syncloud/3rdparty/releases/download/1/gcc-$GCC_VERSION-${ARCH}.tar.gz
tar xf gcc-$GCC_VERSION-${ARCH}.tar.gz
export CC=$DIR/build/gcc-$GCC_VERSION/bin/gcc
export CXX=$DIR/build/gcc-$GCC_VERSION/bin/g++
export PATH=$DIR/build/gcc-$GCC_VERSION/bin:$PATH
gcc --version
$CC --version
$CXX --version

wget --progress=dot:giga https://github.com/syncloud/3rdparty/releases/download/1/python-${ARCH}.tar.gz
tar xf python-${ARCH}.tar.gz
export PATH=$DIR/build/python/bin:$PATH
python --version

echo "building ${NAME}"
cd ${DIR}/build
ARCHIVE=mongodb-src-r${VERSION}.tar.gz
wget https://fastdl.mongodb.org/src/${ARCHIVE} --progress dot:giga

tar xzf ${ARCHIVE}
cd mongodb-src-r${VERSION}
ls -la
cat README
cat docs/building.md
ls -la src

pip install -r buildscripts/requirements.txt
python buildscripts/scons.py CC=$CC CXX=$CXX --disable-warnings-as-errors -j 2 mongod > build.log || tail -1000 build.log
python buildscripts/scons.py CC=$CC CXX=$CXX --disable-warnings-as-errors --prefix=${PREFIX} -j 2 install
strip ${PREFIX}/bin/mongo*

ls -la ${PREFIX}
ls -la ${PREFIX}/bin
ls -la ${PREFIX}/lib || true
mkdir -p ${PREFIX}/lib

mv ${PREFIX}/bin/mongod ${PREFIX}/bin/mongod.bin
ldd ${PREFIX}/bin/mongod.bin

cp --remove-destination /usr/lib/x86_64-linux-gnu/libcurl.so.* ${PREFIX}/lib
#cp --remove-destination /lib/x86_64-linux-gnu/libresolv.so.* ${PREFIX}/lib
cp --remove-destination /lib/x86_64-linux-gnu/librt.so.* ${PREFIX}/lib
#cp --remove-destination /lib/x86_64-linux-gnu/libdl.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/libstdc++.so.* ${PREFIX}/lib
cp --remove-destination /lib/x86_64-linux-gnu/libm.so.* ${PREFIX}/lib
cp --remove-destination /lib/x86_64-linux-gnu/libgcc_s.so.* ${PREFIX}/lib
#cp --remove-destination /lib/x86_64-linux-gnu/libpthread.so.* ${PREFIX}/lib
cp --remove-destination /lib/x86_64-linux-gnu/libc.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/libidn.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/librtmp.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/libssh2.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/libssl.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/libcrypto.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/libgssapi_krb5.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/libkrb5.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/libk5crypto.so.* ${PREFIX}/lib
cp --remove-destination /lib/x86_64-linux-gnu/libcom_err.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/liblber-2.4.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/libldap_r-2.4.so.* ${PREFIX}/lib
cp --remove-destination /lib/x86_64-linux-gnu/libz.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/libgnutls-deb0.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/libhogweed.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/libnettle.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/libgmp.so.* ${PREFIX}/lib
cp --remove-destination /lib/x86_64-linux-gnu/libgcrypt.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/libkrb5support.so.* ${PREFIX}/lib
cp --remove-destination /lib/x86_64-linux-gnu/libkeyutils.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/libsasl2.so.*  ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/libp11-kit.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/libtasn1.so.*  ${PREFIX}/lib
cp --remove-destination /lib/x86_64-linux-gnu/libgpg-error.so.*  ${PREFIX}/lib
cp --remove-destination /usr/lib/x86_64-linux-gnu/libffi.so.* ${PREFIX}/lib

export LD_LIBRARY_PATH=${PREFIX}/lib
ldd ${PREFIX}/bin/mongod.bin

cp ${DIR}/bin/* ${PREFIX}/bin
${PREFIX}/bin/mongod --version

cd ${DIR}

tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
