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
PREFIX_APP=/opt/app/gogs
PREFIX=${PREFIX_APP}/git
VERSION=2.10.1

sudo apt-get -y install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev
sudo apt-get -y install asciidoc xmlto docbook2x
sudo apt-get -y install autoconf

rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

rm -rf ${PREFIX_APP}

wget https://github.com/git/git/archive/v${VERSION}.tar.gz -O v${VERSION}.tar.gz
rm -rf git-${VERSION}
tar xzf v${VERSION}.tar.gz
cd git-${VERSION}

make configure
./configure --prefix=${PREFIX}

make all doc info
make install

cd ${DIR}
rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${PREFIX_APP} ${NAME}
