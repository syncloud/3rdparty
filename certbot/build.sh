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
PYTHON_SITE_PACKAGES_DIR=${BUILD_DIR}/${NAME}/python/lib/python2.7/site-packages
ROOTFS=${BUILD_DIR}/rootfs

if [[ $EUID -ne 0 ]]; then
   echo "non root, skipping apt dependencies"
else
   apt-get update
   apt-get install -y libffi-dev
fi

rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}/${NAME}

cp -r ${DIR}/bin ${BUILD_DIR}/${NAME}

#TODO: coin fails to overwrite existing output
rm -rf .coin.cache/*_python-*/output

coin --to ${BUILD_DIR}/${NAME} raw ${DOWNLOAD_URL}/thirdparty_python_${ARCH}/lastSuccessful/python-${ARCH}.tar.gz

${BUILD_DIR}/${NAME}/python/bin/pip install certbot

coin --to=${PYTHON_SITE_PACKAGES_DIR} py ${DOWNLOAD_URL}/thirdparty_python_cryptography_${ARCH}/lastSuccessful/cryptography-1.3.2-cp27-none-linux_${ARCH}.whl
rm -rf ${PYTHON_SITE_PACKAGES_DIR}/cryptography
mv ${PYTHON_SITE_PACKAGES_DIR}/cryptography-1.3.2/cryptography ${PYTHON_SITE_PACKAGES_DIR}/cryptography
rm -rf ${PYTHON_SITE_PACKAGES_DIR}/cryptography-1.3.2

rm -rf ${DIR}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${BUILD_DIR} .

#coin --to=${ROOTFS} raw ${DOWNLOAD_URL}/debian_rootfs_${ARCH}/lastSuccessful/rootfs.tar.gz

BASE_ROOTFS_ZIP=${BUILD_DIR}/rootfs-${ARCH}.tar.gz
if [ ! -f ${BASE_ROOTFS_ZIP} ]; then
  wget http://build.syncloud.org:8111/guestAuth/repository/download/debian_rootfs_${ARCH}/lastSuccessful/rootfs.tar.gz\
  -O ${BASE_ROOTFS_ZIP} --progress dot:giga
else
  echo "skipping rootfs"
fi
mkdir ${ROOTFS}
tar xzf ${BASE_ROOTFS_ZIP} -C ${ROOTFS}

${DIR}/test.py