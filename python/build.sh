#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

VERSION=2.7.10

export TMPDIR=/tmp
export TMP=/tmp

NAME=python
BUILD_DIR=${DIR}/build
PREFIX=${BUILD_DIR}/${NAME}
OPENSSL_ROOT=${BUILD_DIR}/openssl

apt-get update
apt-get -y install build-essential flex bison libreadline-dev zlib1g-dev libpcre3-dev libssl-dev libbz2-dev

rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}
cd ${BUILD_DIR}

${DIR}/build-openssl.sh

wget https://github.com/yyuu/pyenv/archive/master.zip
unzip master.zip
#export PYTHON_CONFIGURE_OPTS="CPPFLAGS=-I${OPENSSL_ROOT}/include LDFLAGS=-L${OPENSSL_ROOT}/lib"
export PYTHON_CONFIGURE_OPTS="CPPFLAGS=-I${OPENSSL_ROOT}/include LDFLAGS=-L${OPENSSL_ROOT}/lib --enable-shared --enable-unicode=ucs4"
${BUILD_DIR}/pyenv-master/plugins/python-build/bin/python-build --verbose ${VERSION} ${PREFIX}

mv ${PREFIX}/bin/python ${PREFIX}/bin/python.bin
cp ${DIR}/python ${PREFIX}/bin/

mv ${PREFIX}/bin/pip ${PREFIX}/bin/pip_runner
cp ${DIR}/pip ${PREFIX}/bin/

find ${PREFIX}/bin -type f -exec sed -i "s|#!${PREFIX}/|#!|g" {} \;

cd ${DIR}

${PREFIX}/bin/python --version

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}