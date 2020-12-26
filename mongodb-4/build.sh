#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1
#MONGO_ARCH=armv7l
#if [[ ${ARCH} == "amd64" ]]; then
#    MONGO_ARCH=x86_64
#fi

NAME=mongodb-4
VERSION=4.0.21
#GCC_VERSION=5
PREFIX=${DIR}/build/${NAME}

rm -rf ${DIR}/build
mkdir -p $PREFIX

#apt update
#apt remove -y gcc cpp

LD=$(readlink -f /lib64/ld-linux-x86-64.so.2)
$LD /bin/true
$LD /bin/ls /usr

#cd ${DIR}/build
#wget --progress=dot:giga https://github.com/syncloud/3rdparty/releases/download/1/gcc-$GCC_VERSION-${ARCH}.tar.gz
#tar xf gcc-$GCC_VERSION-${ARCH}.tar.gz
#export GCC=$DIR/build/gcc-$GCC_VERSION
#export CC=$GCC/bin/gcc
#export CXX=$GCC/bin/g++
#export PATH=$GCC/bin:$PATH
#gcc --version
#$CC --version
#$CXX --version

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
python buildscripts/scons.py --link-model=static LINKFLAGS="-Wl,-static" --disable-warnings-as-errors -j 2 mongod > build.log || tail -1000 build.log
python buildscripts/scons.py --link-model=static LINKFLAGS="-Wl,-static" --disable-warnings-as-errors --prefix=${PREFIX} -j 2 install
strip ${PREFIX}/bin/mongo*

ls -la ${PREFIX}
ls -la ${PREFIX}/bin
ls -la ${PREFIX}/lib || true
mkdir -p ${PREFIX}/lib

mv ${PREFIX}/bin/mongod ${PREFIX}/bin/mongod.bin
ldd ${PREFIX}/bin/mongod.bin

cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libresolv.so.* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libdl.so.* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libm.so.* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpthread.so.* ${PREFIX}/lib
cp --remove-destination $LD ${PREFIX}/lib/ld.so
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcurl.so.* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/librt.so.* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libstdc++.so.* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgcc_s.so.* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libc.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libidn.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/librtmp.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssh2.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypto.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgssapi_krb5.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libkrb5.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libk5crypto.so.* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcom_err.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/liblber-2.4.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libldap_r-2.4.so.* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libz.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgnutls-deb0.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libhogweed.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libnettle.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgmp.so.* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgcrypt.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libkrb5support.so.* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libkeyutils.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libsasl2.so.*  ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libp11-kit.so.* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libtasn1.so.*  ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgpg-error.so.*  ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libffi.so.* ${PREFIX}/lib

export LD_LIBRARY_PATH=${PREFIX}/lib
ldd ${PREFIX}/bin/mongod.bin

cp ${DIR}/bin/* ${PREFIX}/bin
${PREFIX}/bin/mongod --version

LD_DEBUG=files,libs $LD ${PREFIX}/bin/mongod.bin --version || true
LD_DEBUG=files,libs ${PREFIX}/lib/ld.so --verify ${PREFIX}/bin/mongod.bin || true
LD_DEBUG=files,libs ${PREFIX}/lib/ld.so --list ${PREFIX}/bin/mongod.bin || true

cd ${DIR}

tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
