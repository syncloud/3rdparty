#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

apt update
apt install -y libltdl7 libnss3

ARCH=$(uname -m)
BUILD_DIR=${DIR}/build/python
docker ps -a -q --filter ancestor=python:syncloud --format="{{.ID}}" | xargs docker stop | xargs docker rm || true
docker rmi python:syncloud || true
docker build -t python:syncloud .
docker run python:syncloud python --help
docker create --name=python python:syncloud
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
docker export python -o python.tar
tar xf python.tar
rm -rf python.tar
cp ${DIR}/python ${BUILD_DIR}/bin
cp ${DIR}/pip ${BUILD_DIR}/bin
cp ${DIR}/py.test.sh ${BUILD_DIR}/bin
rm -rf ${BUILD_DIR}/usr/src
cd ${DIR}/build
tar czf $DIR/python-${ARCH}.tar.gz python
