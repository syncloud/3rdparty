#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

ARCH=$(uname -m)
mkdir -p build/php
cd build/php
docker save php:7.4-cli-alpine -o php.tar
tar xf php.tar
cp ${DIR}/php.sh bin
cd ..
tar czvf ${NAME}-${ARCH}.tar.gz php