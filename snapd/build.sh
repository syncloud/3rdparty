#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

export GOPATH=${DIR}
export PATH=${PATH}:${GOPATH}/bin
go get -d -v github.com/snapcore/snapd/...
cd src/github.com/snapcore/snapd
go get -u github.com/kardianos/govendor
govendor sync
./run-checks
