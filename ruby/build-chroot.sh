#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

ROOTFS=rootfs

ROOT_FS_FILENAME="rootfs.tar.gz"
wget -O ${ROOT_FS_FILENAME} http://build.syncloud.org:8111/guestAuth/repository/download/image_armv7l_rootfs/lastSuccessful/${ROOT_FS_FILENAME} --progress dot:giga

mount | grep ${ROOTFS} | awk '{print "umounting "$1; system("umount "$3)}'

rm -rf ${ROOTFS}
mkdir ${ROOTFS}

tar xzf ${ROOT_FS_FILENAME} -C ${ROOTFS}
cp -r ./* ${ROOTFS}/root

chroot ${ROOTFS} /bin/bash -c "mount -t proc proc /proc"
chroot ${ROOTFS} root/build.sh