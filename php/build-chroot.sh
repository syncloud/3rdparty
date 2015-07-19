#!/bin/bash

ROOT_FS_FILENAME="rootfs.tar.gz"
wget -O ${ROOT_FS_FILENAME} http://build.syncloud.org:8111/guestAuth/repository/download/image_armv7l_rootfs/lastSuccessful/${ROOT_FS_FILENAME} --progress dot:giga

mount | grep rootfs | awk '{print "umounting "$1; system("umount "$3)}'

rm -rf rootfs
mkdir rootfs

tar xzf rootfs.tar.gz -C rootfs

cp -r ./* rootfs/root
chroot rootfs root/build.sh