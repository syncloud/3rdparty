#!/bin/bash -x

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

ROOT_FS_FILENAME="rootfs.tar.gz"

if [ ! -f ${ROOT_FS_FILENAME} ]; then
    echo "rootfs is not ready"
    exit 1
fi

VERSION=2.7.10
SOURCES_URL=https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz

rm -rf rootfs
tar xzf ${ROOT_FS_FILENAME}
cp -r ./* rootfs/root
#chroot rootfs root/build.sh ${SOURCES_URL} python-${VERSION}-armv7l
chroot rootfs root/build.sh ${SOURCES_URL} python
