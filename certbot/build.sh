#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1
NAME=certbot
BUILD_DIR=${DIR}/build
LIB_DIR=${BUILD_DIR}/lib
TEST_DIR=${DIR}/test
DOWNLOAD_URL=http://build.syncloud.org:8111/guestAuth/repository/download
PYPI_URL=https://pypi.python.org/packages

rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}

cp -r ${DIR}/bin ${BUILD_DIR}

#TODO: coin fails to overwrite existing output
rm -rf .coin.cache/*_python-*/output

coin --to ${BUILD_DIR} raw ${DOWNLOAD_URL}/thirdparty_python_${ARCH}/lastSuccessful/python-${ARCH}.tar.gz

${BUILD_DIR}/python/bin/pip install certbot,

rm -rf ${DIR}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${BUILD_DIR} .

${DIR}/test.py