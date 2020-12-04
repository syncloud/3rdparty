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

NAME=gcc-5
VERSTION=5.5.0
PREFIX=${DIR}/build/${NAME}

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
$DIR/build/gcc-${VERSTION}/configure --prefix=$PREFIX --disable-multilib
make -j 2 > build.log
make install-strip

$PREFIX/bin/gcc --version

cd ${DIR}

tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
