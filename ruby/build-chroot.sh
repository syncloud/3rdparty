#!/bin/bash

if [ ! -d ${DIR}/3rdparty ]; then
    mkdir ${DIR}/3rdparty
fi

if [ ! -f ${DIR}/3rdparty/rootfs.tar.gz ]; then
    wget -O ${DIR}/3rdparty/rootfs.tar.gz http://build.syncloud.org:8111/guestAuth/repository/download/image_armv7l_rootfs/lastSuccessful/rootfs.tar.gz --progress dot:giga
else
    echo "skipping rootfs.tar.gz"
fi


mount | grep rootfs | awk '{print "umounting "$1; system("umount "$3)}'

rm -rf /tmp/rootfs
mkdir /tmp/rootfs

tar xzf rootfs.tar.gz -C /tmp/rootfs
cp -r ./* /tmp/rootfs/root

chroot /tmp/rootfs /bin/bash -c "mount -t proc proc /proc"
chroot /tmp/rootfs root/build.sh