#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

export TMPDIR=/tmp
export TMP=/tmp
NAME="MarkupSafe"
VERSION="0.23"
FULL_NAME="${NAME}-${VERSION}"

echo "building ${NAME}"

apt-get -y install python
wget -O get-pip.py https://bootstrap.pypa.io/get-pip.py --progress dot:giga
python get-pip.py
rm get-pip.py
pip install wheel

apt-get install -y build-essential python-dev

rm -rf build
mkdir build

cd ${DIR}/build
mkdir ${NAME}
wget -O ${FULL_NAME}.tar.gz https://pypi.python.org/packages/source/M/${NAME}/${FULL_NAME}.tar.gz --progress dot:giga
tar zxf ${FULL_NAME}.tar.gz -C ${NAME} --strip-components=1
rm -rf ${FULL_NAME}.tar.gz

cd ${NAME}
python setup.py bdist_wheel

