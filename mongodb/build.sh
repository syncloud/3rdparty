#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

NAME=mongodb
VERSION=3.0.14
PREFIX=${DIR}/build/${NAME}

rm -rf $PREFIX
mkdir -p $PREFIX
cd $PREFIX

#echo "repackage distro version"
#apt-get update
#apt-get -y install mongodb
#mkdir bin
#cp /usr/bin/mongod bin/mongod.bin
#cp $DIR/bin/* bin/
#mkdir conf
#cp /etc/mongodb.conf conf/


echo "building ${NAME}"

ARCHIVE=${NAME}-src-r${VERSION}.tar.gz
wget https://fastdl.mongodb.org/src/${ARCHIVE} --progress dot:giga

tar xzf ${ARCHIVE}
cd ${NAME}-src-r${VERSION}
ls -la
cat README
cat docs/building.md
ls -la src

#echo "deb http://ftp.us.debian.org/debian unstable main contrib non-free" >> /etc/apt/sources.list.d/unstable.list
#apt-get update
#apt-get -y install -t unstable gcc-5 g++-5
#update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 10  
#update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 10
#update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30 
#update-alternatives --set cc /usr/bin/gcc 
#update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30 
#update-alternatives --set c++ /usr/bin/g++ 

#gcc --version

#pip install -r buildscripts/requirements.txt
pip install scons==2.3.0
mv /usr/local/lib/python2.7/dist-packages/scons-* /usr/local/lib/python2.7/site-packages/ | true
#python --version

#https://gist.github.com/kitsook/f0f53bc7acc468b6e94c
ls -la src/third_party
cp $DIR/SConscript src/third_party/v8-3.25/
scons --prefix=$PREFIX -j 2 --ssl --wiredtiger=off --js-engine=v8-3.25 --c++11=off --disable-warnings-as-errors CXXFLAGS="-std=gnu++11" core install

ldd bin/mongod.bin

mkdir lib
cp /usr/lib/libv8.so* lib/
cp /usr/lib/libsnappy.so* lib/
cp	 /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpcre.so* lib/
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpcrecpp.so* lib/
cp	 /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl.so* lib/
cp 	/usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypto.so* lib/
cp 	/usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)p/libboost_thread.so* lib/
cp 	/usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libboost_filesystem.so* lib/
cp 	/usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libboost_program_options.so* lib/
cp 	/usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libboost_system.so* lib/
cp 	/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/librt.so* lib/
cp 	/usr/lib/libtcmalloc.so* lib/ || true
#	libstdc++.so.6 => /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libstdc++.so.6 (0x00007f548ba6d000)
#	libm.so.6 => /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libm.so.6 (0x00007f548b76b000)
#	libgcc_s.so.1 => /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgcc_s.so.1 (0x00007f548b555000)
#	libc.so.6 => /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libc.so.6 (0x00007f548b1aa000)
#	/lib64/ld-linux-x86-64.so.2 (0x0000563f87812000)
#	libdl.so.2 => /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libdl.so
cp /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libunwind.so* lib/ || true
cp /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/liblzma.so* lib/

export LD_LIBRARY_PATH=${PREFIX}/lib

ldd bin/mongod.bin

./bin/mongod --version

cd $DIR

tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
