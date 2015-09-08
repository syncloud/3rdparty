#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

HOME=/root
ROOTFS=/tmp/rootfs
ROOTFS_FILENAME="rootfs.tar.gz"
ROOTFS_FILE="/tmp/${ROOTFS_FILENAME}"

if [ ! -f ${ROOTFS_FILE} ]; then
   wget -O ${ROOTFS_FILE} http://build.syncloud.org:8111/guestAuth/repository/download/image_armv7l_rootfs/lastSuccessful/${ROOTFS_FILENAME} --progress dot:giga
else
    echo "${ROOTFS_FILE} is here"
fi

function cleanup {

    mount | grep ${ROOTFS}
    mount | grep ${ROOTFS} | awk '{print "umounting "$1; system("umount "$3)}'
    mount | grep ${ROOTFS}
    echo " cleanup done"
}

cleanup

rm -rf ${ROOTFS}
mkdir ${ROOTFS}

tar xzf ${ROOTFS_FILE} -C ${ROOTFS}

cp -r * ${ROOTFS}/root/
chroot ${ROOTFS} /bin/bash -c "mount -t proc proc /proc"
chroot ${ROOTFS} root/build.sh armv7l

cleanup