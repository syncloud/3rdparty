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
PREFIX=${DIR}/build/${NAME}

rm -rf ${DIR}/build
mkdir -p $PREFIX
cd ${DIR}/build

echo "building ${NAME}"

ARCHIVE=mongodb-src-r${VERSION}.tar.gz
wget https://fastdl.mongodb.org/src/${ARCHIVE} --progress dot:giga

tar xzf ${ARCHIVE}
cd mongodb-src-r${VERSION}
ls -la
cat README
cat docs/building.md
ls -la src

apt-get update
apt-get install -y python-pip python-dev libssl-dev
pip install -r buildscripts/requirements.txt
python buildscripts/scons.py --disable-warnings-as-errors -j 2 mongod
python buildscripts/scons.py --disable-warnings-as-errors --prefix=${PREFIX} -j 2 install
strip ${PREFIX}/mongo*

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