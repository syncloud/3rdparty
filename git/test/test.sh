#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

NAME=git
ARCH=$(dpkg-architecture -q DEB_HOST_GNU_CPU)
ROOTFS=${DIR}/.rootfs

if [ ! -f "rootfs.tar.gz" ]; then
    wget http://build.syncloud.org:8111/guestAuth/repository/download/${DISTRO}_rootfs_syncloud_${ARCH}/lastSuccessful/rootfs.tar.gz\
  -O rootfs.tar.gz --progress dot:giga
else
    echo "rootfs.tar.gz is here"
fi

rm -rf ${ROOTFS}
mkdir ${ROOTFS}
tar xzf rootfs.tar.gz -C ${ROOTFS}

tar xzvf ${NAME}-${ARCH}.tar.gz -C ${ROOTFS}

chroot ${ROOTFS}/${NAME}/git/bin/git config -l

