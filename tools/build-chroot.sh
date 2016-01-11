#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    ARCH=armv7l
else
    ARCH=$1
fi

HOME=/root
ROOTFS=/tmp/rootfs
ROOTFS_FILENAME="rootfs.tar.gz"
ROOTFS_FILE="${DIR}/rootfs-${ARCH}.tar.gz"

if [ ! -z "$TEAMCITY_VERSION" ]; then
  echo "running under TeamCity, cleaning coin cache"
  rm -rf ${ROOTFS_FILE}
fi

if [ ! -f ${ROOTFS_FILE} ]; then
   wget -O ${ROOTFS_FILE} http://build.syncloud.org:8111/guestAuth/repository/download/debian_rootfs_${ARCH}/lastSuccessful/${ROOTFS_FILENAME} --progress dot:giga
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

echo "installing dependencies"
sudo apt-get -y install qemu-user-static

echo "enabling arm binary support"
cp $(which qemu-arm-static) ${ROOTFS}/usr/bin

cp -r * ${ROOTFS}/root/
chroot ${ROOTFS} /bin/bash -c "mount -t proc proc /proc"
mount --bind /dev/pts ${ROOTFS}/dev/pts
chroot ${ROOTFS} root/build.sh ${ARCH} $2

cleanup