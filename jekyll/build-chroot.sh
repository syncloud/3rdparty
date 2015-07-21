#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

ROOTFS=/tmp/jekyll/rootfs

if [ ! -d ${DIR}/3rdparty ]; then
    mkdir ${DIR}/3rdparty
fi
if [ ! -f ${DIR}/3rdparty/rootfs.tar.gz ]; then
    wget -O ${DIR}/3rdparty/rootfs.tar.gz http://build.syncloud.org:8111/guestAuth/repository/download/image_armv7l_rootfs/lastSuccessful/rootfs.tar.gz --progress dot:giga
else
    echo "skipping rootfs.tar.gz"
fi


mount | grep ${ROOTFS} | awk '{print "umounting "$1; system("umount "$3)}'

rm -rf ${ROOTFS}
mkdir -p ${ROOTFS}

tar xzf ${DIR}/3rdparty/rootfs.tar.gz -C ${ROOTFS}
cp -r ./* ${ROOTFS}/root

chroot ${ROOTFS} /bin/bash -c "mount -t proc proc /proc"
chroot ${ROOTFS} root/build.sh armv7l
cp ${ROOTFS}/root/jekyll.tar.gz .