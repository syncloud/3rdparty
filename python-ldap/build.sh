#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

export TMPDIR=/tmp
export TMP=/tmp
NAME="python-ldap"
VERSION="2.4.19"
FULL_NAME="${NAME}-${VERSION}"

echo "building ${NAME}"

apt-get -y install python
wget -O get-pip.py https://bootstrap.pypa.io/get-pip.py
python get-pip.py
rm get-pip.py
pip install wheel

apt-get install -y python-dev libldap2-dev libsasl2-dev libssl-dev

rm -rf build
mkdir build

cd ${DIR}/build

wget -O ${FULL_NAME}.tar.gz https://pypi.python.org/packages/source/p/python-ldap/${FULL_NAME}.tar.gz
tar zxvf ${FULL_NAME}.tar.gz
rm -rf ${FULL_NAME}.tar.gz

cd ${FULL_NAME}
python setup.py bdist_wheel

