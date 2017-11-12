#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

NAME=mongodb
#VERSION=3.4.10
PREFIX=${DIR}/build/${NAME}

apt-get update
apt-get -y install mongodb

#echo "building ${NAME}"

rm -rf $PREFIX
mkdir -p $PREFIX
cd $PREFIX

mkdir bin
cp /usr/bin/mongod bin/

mkdir conf
cp /etc/init/mongodb.conf conf/

ldd bin/mongod

mkdir lib
cp /usr/lib/libv8.so* lib/
cp /usr/lib/libsnappy.so* lib/
cp	 /lib/(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpcre.so* lib/
cp /usr/lib/(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libpcrecpp.so* lib/
cp	 /usr/lib/(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl.so* lib/
cp 	/usr/lib/(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypto.so* lib/
cp 	/usr/lib/(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libboost_thread.so* lib/
cp 	/usr/lib/(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libboost_filesystem.so* lib/
cp 	/usr/lib/(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libboost_program_options.so* lib/
cp 	/usr/lib/(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libboost_system.so* lib/
cp 	/lib/(dpkg-architecture -q DEB_HOST_GNU_TYPE)/librt.so* lib/
cp 	/usr/lib/libtcmalloc.so* lib/
#	libstdc++.so.6 => /usr/lib/(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libstdc++.so.6 (0x00007f548ba6d000)
#	libm.so.6 => /lib/(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libm.so.6 (0x00007f548b76b000)
#	libgcc_s.so.1 => /lib/(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libgcc_s.so.1 (0x00007f548b555000)
#	libc.so.6 => /lib/(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libc.so.6 (0x00007f548b1aa000)
#	/lib64/ld-linux-x86-64.so.2 (0x0000563f87812000)
#	libdl.so.2 => /lib/(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libdl.so
cp /usr/lib/(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libunwind.so* lib/
cp /lib/(dpkg-architecture -q DEB_HOST_GNU_TYPE)/liblzma.so* lib/

export LD_LIBRARY_PATH=${PREFIX}/lib

ldd bin/mongod

#ARCHIVE=${NAME}-src-r${VERSION}.tar.gz
#wget https://fastdl.mongodb.org/src/${ARCHIVE} --progress dot:giga
#tar xzf ${ARCHIVE}
#cd ${NAME}-src-r${VERSION}
#ls -la
#cat README
#cat docs/building.md
#ls -la src
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
#pip install scons==2.3.0
#mv /usr/local/lib/python2.7/dist-packages/scons-* /usr/local/lib/python2.7/site-packages/ | true
#python --version
#scons --prefix=$PREFIX install

cd $DIR

tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
