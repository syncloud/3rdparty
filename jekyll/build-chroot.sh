#!/bin/bash

ROOT_FS_FILENAME="rootfs.tar.gz"
wget -O ${ROOT_FS_FILENAME} http://build.syncloud.org:8111/guestAuth/repository/download/image_armv7l_rootfs/lastSuccessful/${ROOT_FS_FILENAME} --progress dot:giga

tar xzf rootfs.tar.gz
cp -r ./* rootfs/root

mount | grep rootfs | awk '{print "umounting "$1; system("umount "$3)}'
chroot rootfs /bin/bash -c "mount -t proc proc /proc"
chroot rootfs root/build.sh armv7l