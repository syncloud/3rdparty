#!/bin/bash


DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

export TMPDIR=/tmp
export TMP=/tmp
NAME=ruby
VERSION=2.1.5
ROOT=/opt/app/platform
PREFIX=${ROOT}/${NAME}

echo "building ${NAME}"

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

curl -sSL https://get.rvm.io | bash -s stable --ruby=${VERSION}

apt-get -y install build-essential flex bison libreadline-dev zlib1g-dev libpcre3-dev

rm -rf build
mkdir -p build
cd build

wget http://nginx.org/download/${NAME}-${VERSION}.tar.gz
tar xzf ${NAME}-${VERSION}.tar.gz
cd ${NAME}-${VERSION}
./configure --prefix=${PREFIX}
make -j2
rm -rf ${PREFIX}
make install
cd ../..

rm -rf ${NAME}.tar.gz
tar cpzf ${NAME}.tar.gz -C  ${HOME}/.rvm/rubies ${NAME}-${VERSION}