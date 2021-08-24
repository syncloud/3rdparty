#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}
BUILD_DIR=${DIR}/build/openldap

ARCH=$(uname -m)
docker ps -a -q --filter ancestor=openldap:syncloud --format="{{.ID}}" | xargs docker stop | xargs docker rm || true
docker rmi openldap:syncloud || true
docker pull osixia/openldap:1.5.0
docker build -t openldap:syncloud .
docker run openldap:syncloud openldap -i
docker create --name=openldap openldap:syncloud
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
docker export openldap -o openldap.tar
tar xf openldap.tar
rm -rf openldap.tar
cp ${DIR}/slapadd.sh ${BUILD_DIR}/sbin
cp ${DIR}/ldapadd.sh ${BUILD_DIR}/bin

cd ${DIR}/build
tar czf $DIR/openldap-${ARCH}.tar.gz openldap
