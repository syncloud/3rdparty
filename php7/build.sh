#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

ARCH=$(uname -m)
mkdir -p build/php
cd build/php
docker rm php | true
docker rmi php | true
docker pull php:7.4-cli
docker build -t php:syncloud .
docker run --name=php php:syncloud php -v
docker export php -o php.tar
tar xf php.tar
cp ${DIR}/php.sh bin
cd ..
tar czvf ${NAME}-${ARCH}.tar.gz php