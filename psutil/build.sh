#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

export TMPDIR=/tmp
export TMP=/tmp
NAME="psutil"
VERSION="3.0.0"
FULL_NAME="${NAME}-${VERSION}"

echo "building ${NAME}"

apt-get -y install python
wget -O get-pip.py https://bootstrap.pypa.io/get-pip.py
python get-pip.py
rm get-pip.py
pip install wheel

apt-get install -y python-dev

rm -rf build
mkdir build

cd ${DIR}/build
mkdir ${NAME}
wget -O ${FULL_NAME}.tar.gz https://pypi.python.org/packages/source/p/${NAME}/${FULL_NAME}.tar.gz
tar zxvf ${FULL_NAME}.tar.gz -C ${NAME} --strip-components=1
rm -rf ${FULL_NAME}.tar.gz

cd ${NAME}
python setup.py bdist_wheel

