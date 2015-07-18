#!/bin/bash -x

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

SOURCES_URL=$1
BINARIES_FILENAME=$2

export TMPDIR=/tmp
export TMP=/tmp

NAME=python
PREFIX=${DIR}/build/${NAME}

apt-get -y install build-essential flex bison libreadline-dev zlib1g-dev libpcre3-dev libssl-dev curl git
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash

rm -rf build
mkdir build

export PYTHON_CONFIGURE_OPTS="--enable-shared"
~/.pyenv/plugins/python-build/bin/python-build 2.7.10 ${PREFIX}
mv ${PREFIX}/bin/python ${PREFIX}/bin/python.bin
cp python ${PREFIX}/bin/
cd ${DIR}/build
tar cpzf ${BINARIES_FILENAME}.tar.gz ${NAME}
