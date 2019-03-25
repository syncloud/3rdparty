#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

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

#http://andyfelong.com/2015/12/mongodb-3-0-7-on-raspberry-pi-2/
apt-get update
apt-get -y install libboost-filesystem-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev
pip install scons==2.3.0
mv /usr/local/lib/python2.7/dist-packages/scons-* /usr/local/lib/python2.7/site-packages/ | true
#pip2 install -r buildscripts/requirements.txt 

#https://gist.github.com/kitsook/f0f53bc7acc468b6e94c
ls -la src/third_party
cp $DIR/SConscript src/third_party/v8-3.25/
scons -j 2 --wiredtiger=off --c++11=off --js-engine=v8-3.25 --disable-warnings-as-errors CXXFLAGS="-std=gnu++11" core
scons --prefix=$PREFIX -j 2 --wiredtiger=off --c++11=off --js-engine=v8-3.25 --disable-warnings-as-errors CXXFLAGS="-std=gnu++11" install
#python2 buildscripts/scons.py all

ls -la $PREFIX
ls -la $PREFIX/bin
ls -la $PREFIX/lib || true

mv $PREFIX/bin/mongod $PREFIX/bin/mongod.bin
ldd $PREFIX/bin/mongod.bin

#mkdir $PREFIX/lib
#export LD_LIBRARY_PATH=${PREFIX}/lib
#ldd $PREFIX/bin/mongod.bin

cp $DIR/bin/* $PREFIX/bin
$PREFIX/bin/mongod --version

cd $DIR

tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
