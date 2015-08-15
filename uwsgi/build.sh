#!/bin/bash


DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

export TMPDIR=/tmp
export TMP=/tmp

NAME=uwsgi
VERSION=2.0.10

echo "building ${NAME}"

apt-get -y install build-essential python-dev

rm -rf build
mkdir -p build
cd build

wget http://projects.unbit.it/downloads/${NAME}-${VERSION}.tar.gz --progress dot:giga
tar xzf ${NAME}-${VERSION}.tar.gz
cd ${NAME}-${VERSION}

python uwsgiconfig.py --build

cd ../..

mkdir -p install/${NAME}/bin
cp build/${NAME}-${VERSION}/uwsgi install/${NAME}/bin/

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C install ${NAME}