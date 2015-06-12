#!/bin/bash -x

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

VERSION=2.7.10
SOURCES_URL=https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz

#./build.sh ${SOURCES_URL} python-${VERSION}-x64
./build.sh ${SOURCES_URL} python