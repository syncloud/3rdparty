#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

ARCH=$(uname -m)
docker rm php | true
docker rmi php:syncloud | true
docker pull php:7.4-cli
docker build -t php:syncloud .
docker create --name=php php:syncloud php -i
mkdir -p build/php
cd build/php
docker export php -o php.tar
tar xf php.tar
rm -rf php.tar
cp ${DIR}/php.sh bin
./bin/php.sh -v
cd ..
tar czvf php7-${ARCH}.tar.gz php