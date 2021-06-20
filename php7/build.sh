#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}
BUILD_DIR=${DIR}/build/php

ARCH=$(uname -m)
docker ps -a -q --filter ancestor=php:syncloud --format="{{.ID}}" | xargs docker stop | xargs docker rm || true
docker rmi php:syncloud || true
docker pull php:7.4-cli
docker build -t php:syncloud .
docker run php:syncloud php -i
docker create --name=php php:syncloud
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
docker export php -o php.tar
tar xf php.tar
rm -rf php.tar
cd ${BUILD_DIR}/usr/lib
LIB_ARCH=$(echo *-linux*)
cd $LIB_ARCH
IMAGE_MAGIC_NAME=$(echo ImageMagick-*)
cd ${BUILD_DIR}/usr/lib
ln -s $LIB_ARCH/$IMAGE_MAGIC_NAME $IMAGE_MAGIC_NAME
ls -la ImageMagick*
cp ${DIR}/php.sh ${BUILD_DIR}/bin
${BUILD_DIR}/bin/php.sh -v
cd ${DIR}/build
tar czvf php7-${ARCH}.tar.gz php