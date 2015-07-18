#!/bin/bash -x

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export DEBCONF_FRONTEND=noninteractive
export DEBIAN_FRONTEND=noninteractive
export TMPDIR=/tmp
export TMP=/tmp

ROOT_FS_FILENAME="rootfs.tar.gz"
wget -O ${ROOT_FS_FILENAME} http://build.syncloud.org:8111/guestAuth/repository/download/image_armv7l_rootfs/lastSuccessful/${ROOT_FS_FILENAME} --progress dot:giga

VERSION=2.7.10
SOURCES_URL=https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz

rm -rf rootfs
mkdir rootfs
tar xzf ${ROOT_FS_FILENAME} -C rootfs
cp -r ./* rootfs/root
chroot rootfs root/build.sh ${SOURCES_URL} python
