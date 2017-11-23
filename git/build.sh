#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

NAME=git
BUILD_DIR=${DIR}/build
PREFIX=${BUILD_DIR}/${NAME}
VERSION=2.10.1
DPKG_ARCH=$(dpkg-architecture -q DEB_HOST_GNU_TYPE)

rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
https://www.kernel.org/pub/software/scm/git/git-${VERSION}.tar.gz --progress dot:giga
tar xf git-${VERSION}.tar.gz
cd git-${VERSION}

make configure
./configure --prefix=${PREFIX}

make all doc info
make install

mv ${PREFIX}/bin/git ${PREFIX}/bin/git.bin
cp -r ${DIR}/bin/git ${PREFIX}/bin/git
chmod +x ${PREFIX}/bin/git

echo "original libs"
ldd ${PREFIX}/bin/git.bin

cp --remove-destination /usr/lib/${DPKG_ARCH}/libcurl.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/${DPKG_ARCH}/libcrypto.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/${DPKG_ARCH}/libssl.so* ${PREFIX}/lib

echo "embedded libs"
export LD_LIBRARY_PATH=${PREFIX}/lib
ldd ${PREFIX}/bin/git.bin

cd ${DIR}
rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${BUILD_DIR} ${NAME}

# test

${PREFIX}/bin/git config -l
mkdir test
cd test
${PREFIX}/bin/git init
touch test
${PREFIX}/bin/git add test
${PREFIX}/bin/git commit -m "test" --author "test <test@test.com>"