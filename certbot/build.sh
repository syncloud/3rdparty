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

coin --to=${LIB_DIR} py ${PYPI_URL}/b6/b2/789558734fb2ff426fb4c0e948e2cbae18af50bd54bab8c4cc012d9dce10/certbot-0.6.0-py2-none-any.whl
coin --to=${LIB_DIR} py ${PYPI_URL}/b0/fb/75ba188a2134ed0a92de37e2644448789d05b3cdb262d0c1da284890a98f/acme-0.6.0-py2.py3-none-any.whl
coin --to=${LIB_DIR} py ${PYPI_URL}/c8/0a/b6723e1bc4c516cb687841499455a8505b44607ab535be01091c0f24f079/six-1.10.0-py2.py3-none-any.whl
coin --to=${LIB_DIR} py ${PYPI_URL}/a6/4b/d2614fef376fcc5d0de1e86d1758c75ef79eda345ecfa07e0d16676706c3/enum34-1.1.5-py2.py3-none-any.whl
coin --to=${LIB_DIR} py ${PYPI_URL}/b1/4e/54c8995d2de887919272c2b711cd430277ec33e0f7bb88cb564244c102b6/pyOpenSSL-16.0.0-py2.py3-none-any.whl
coin --to=${LIB_DIR} py ${PYPI_URL}/9b/0a/decfa17e7707afca17d6e9595ff5c79c1c71c74063ad95576f897ed3a9f1/pyRFC3339-1.0-py2.py3-none-any.whl
coin --to=${LIB_DIR} py ${PYPI_URL}/ae/cf/a7442138ad899a7587489641a8923f1e640cafc2d6ffe4e79e5d15cc5b3e/pytz-2016.4-py2.py3-none-any.whl
coin --to=${LIB_DIR} py ${PYPI_URL}/99/b4/63d99ba8e189c47d906b43bae18af4396e336f2b1bfec86af31efe2d2cb8/requests-2.10.0-py2.py3-none-any.whl

coin --to=${LIB_DIR} py ${DOWNLOAD_URL}/thirdparty_python_cryptography_${ARCH}/lastSuccessful/cryptography-1.3.2-cp27-none-linux_${ARCH}.whl

coin --to=${LIB_DIR} py ${DOWNLOAD_URL}/thirdparty_python_cryptography_${ARCH}/lastSuccessful/cffi-1.6.0-cp27-none-linux_${ARCH}.whl

rm -rf tmp
mkdir tmp
coin --to=tmp py ${PYPI_URL}/9d/81/2509ca3c6f59080123c1a8a97125eb48414022618cec0e64eb1313727bfe/zope.interface-4.1.3.tar.gz
mv tmp/zope.interface-4.1.3/src ${LIB_DIR}/zope.interface-4.1.3

rm -rf tmp
mkdir tmp
coin --to=tmp py ${PYPI_URL}/4c/c4/3f77127c876f49af478e8ea4dc223cda17730bb273c0d1606a4114c64008/zope.component-4.2.2.tar.gz
mv tmp/zope.component-4.2.2/src ${LIB_DIR}/zope.component-4.2.2

rm -rf ${DIR}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${BUILD_DIR} .

rm -rf ${TEST_DIR}
mkdir ${TEST_DIR}

#TODO: coin fails to overwrite existing output
rm -rf .coin.cache/*_python-*/output

coin --to ${TEST_DIR} raw ${DOWNLOAD_URL}/thirdparty_python_${ARCH}/lastSuccessful/python-${ARCH}.tar.gz
path_file=${TEST_DIR}/python/lib/python2.7/site-packages/path.pth
ls ${BUILD_DIR}/lib/  > ${path_file}
sed -i "s#^#../../../../../build/lib/#g" ${path_file}

${DIR}/test.py