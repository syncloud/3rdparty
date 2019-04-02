#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1
LIB_ARCH=linux-armv6
TOOLCHAIN_ARCH=linux-armv7
if [[ ${ARCH} == "x86_64" ]]; then
    LIB_ARCH=linux-x64
    TOOLCHAIN_ARCH=linux-x64
fi

NAME=libvips
VERSION=8.7.4

rm -rf ${DIR}/build
cd ${DIR}/build

echo "building ${NAME}"
apt update
apt install -y jq intltool cmake nasm gtk-doc-tools texinfo gperf advancecomp libglib2.0-dev gobject-introspection
curl https://sh.rustup.rs -sSf | sh -s -- -y
export PATH=/root/.cargo/bin:$PATH
wget https://github.com/lovell/sharp-libvips/archive/v${VERSION}.tar.gz
tar xf v${VERSION}.tar.gz
cd sharp-libvips-${VERSION}
cp ${TOOLCHAIN_ARCH}/Toolchain.cmake /root
cd build
export VERSION_VIPS=${VERSION}
export PLATFORM=${LIB_ARCH}
mkdir /packaging
sed -i 's/VERSION_HARFBUZZ=.*/VERSION_HARFBUZZ=2.4.0/g' ./lin.sh
./lin.sh 
ls -la /packaging
tar tvf /packaging/libvips-*.tar.gz

cd ${DIR}
cp /packaging/libvips-*.tar.gz .
