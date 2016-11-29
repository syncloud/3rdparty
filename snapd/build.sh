#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

export GOPATH=${DIR}
export PATH=${PATH}:${GOPATH}/bin
BUILD_DIR=${DIR}/build

go get -d -v github.com/snapcore/snapd/...
cd src/github.com/snapcore/snapd
go get -u github.com/kardianos/govendor
govendor sync
#./run-checks

cd ${DIR}
rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}
go build -o ${BUILD_DIR}/snapd github.com/snapcore/snapd/cmd/snapd
