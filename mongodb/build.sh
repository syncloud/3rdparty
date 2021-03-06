#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1
MONGO_ARCH=arm
if [[ ${ARCH} == "amd64" ]]; then
    MONGO_ARCH=x86_64
fi

NAME=mongodb
VERSION=3.2.22
PREFIX=${DIR}/build/${NAME}

rm -rf ${DIR}/build
mkdir -p $PREFIX
cd ${DIR}/build

echo "building ${NAME}"

ARCHIVE=${NAME}-src-r${VERSION}.tar.gz
wget https://fastdl.mongodb.org/src/${ARCHIVE} --progress dot:giga

tar xzf ${ARCHIVE}
cd ${NAME}-src-r${VERSION}
ls -la
cat README
cat docs/building.md
ls -la src

#apt-get update
#apt-get -y install libboost-filesystem-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev
pip install scons==2.3.0
mv /usr/local/lib/python2.7/dist-packages/scons-* /usr/local/lib/python2.7/site-packages/ | true

ls -la src/third_party

cd src/third_party/mozjs-38/
./get_sources.sh
./gen-config.sh ${MONGO_ARCH} linux
cd ../../../

scons -j 2 --wiredtiger=off --mmapv1=on mongod
scons --prefix=${PREFIX} -j 2 --wiredtiger=off --mmapv1=on install

ls -la ${PREFIX}
ls -la ${PREFIX}/bin
ls -la ${PREFIX}/lib || true
mkdir -p ${PREFIX}/lib

mv ${PREFIX}/bin/mongod ${PREFIX}/bin/mongod.bin
ldd ${PREFIX}/bin/mongod.bin

cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libstdc++.so* ${PREFIX}/lib

export LD_LIBRARY_PATH=${PREFIX}/lib
ldd ${PREFIX}/bin/mongod.bin

cp ${DIR}/bin/* ${PREFIX}/bin
${PREFIX}/bin/mongod --version

cd ${DIR}

tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
