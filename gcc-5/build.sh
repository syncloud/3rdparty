#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

PACKAGE_ARCH=$1
OPTS=""
#if [[ ${PACKAGE_ARCH} == "arm" ]]; then
    #OPTS="--with-arch=armv6 --with-fpu=vfp --with-float=hard --build=arm-linux-gnueabihf --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf"
#fi

NAME=gcc-5
VERSTION=5.5.0
PREFIX=${DIR}/build/${NAME}
apt update
apt install -y libc6 libc6-dev

rm -rf ${DIR}/build
mkdir -p $PREFIX

cd ${DIR}/build
wget ftp://ftp.gnu.org/gnu/gcc/gcc-${VERSTION}/gcc-${VERSTION}.tar.xz --progress dot:giga
tar xf gcc-${VERSTION}.tar.xz
cd gcc-${VERSTION}
./contrib/download_prerequisites
cd ..
mkdir objdir
cd objdir
$DIR/build/gcc-${VERSTION}/configure --prefix=$PREFIX --disable-multilib  --enable-languages=c,c++ $OPTS
make -j 4 > build.log
make install-strip

$PREFIX/bin/gcc --version

cd ${DIR}

tar cpzf ${NAME}-${PACKAGE_ARCH}.tar.gz -C ${DIR}/build ${NAME}
