#!/bin/bash -x

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

SOURCES_URL=$1
BINARIES_FILENAME=$2

export TMPDIR=/tmp
export TMP=/tmp

NAME=python
PREFIX=${DIR}/build/${NAME}

apt-get -y install build-essential flex bison libreadline-dev zlib1g-dev libpcre3-dev

rm -rf build
mkdir build

cd ${DIR}/build

wget -O sources.tgz ${SOURCES_URL}

tar zxvf sources.tgz

INNER_FOLDER_NAME=$(ls -1)

cd ${INNER_FOLDER_NAME}

./configure --prefix=${PREFIX} --enable-shared
make install

cd ..

tar cpzf ${BINARIES_FILENAME}.tar.gz ${NAME}
