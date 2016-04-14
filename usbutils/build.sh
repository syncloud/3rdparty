#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

export TMPDIR=/tmp
export TMP=/tmp

NAME="usbutils"

if [[ -z "$1" ]]; then
    echo "usage $0 app_arch"
    exit 1
fi

ARCH=$1

ARCH_DEB="unknown"
if [ "${ARCH}" == 'x86_64' ]; then
    ARCH_DEB="amd64"
fi
if [ "${ARCH}" == 'armv7l' ]; then
    ARCH_DEB="armhf"
fi

echo "building ${NAME}"

apt-get -y install python usbutils
wget -O get-pip.py https://bootstrap.pypa.io/get-pip.py --progress dot:giga
python get-pip.py
rm get-pip.py

BUILD_DIR=${DIR}/build/${NAME}
rm -rf build
mkdir -p ${BUILD_DIR}

cp -r ${DIR}/bin ${BUILD_DIR}

coin --to ${BUILD_DIR} deb http://http.us.debian.org/debian/pool/main/u/usbutils/usbutils_007-2_${ARCH_DEB}.deb --subfolder usbutils
coin --to ${BUILD_DIR} deb http://http.us.debian.org/debian/pool/main/libu/libusb-1.0/libusb-1.0-0_1.0.19-1_${ARCH_DEB}.deb --subfolder libusb

echo "zipping"
rm -rf ${NAME}*.tar.gz
tar cpzf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${DIR}/build/ ${NAME}