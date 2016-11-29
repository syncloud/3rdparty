#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

export GOPATH=${DIR}
export PATH=${PATH}:${GOPATH}/bin
NAME=snapd
BUILD_DIR=${DIR}/build/${NAME}
ARCH=$(dpkg-architecture -q DEB_HOST_ARCH)

go get -d -v github.com/snapcore/snapd/...
cd src/github.com/snapcore/snapd
go get -u github.com/kardianos/govendor
govendor sync
#./run-checks

cd ${DIR}
rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
go build -o ${BUILD_DIR}/snapd github.com/snapcore/snapd/cmd/snapd

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
