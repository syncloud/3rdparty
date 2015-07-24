#!/bin/bash

ROOT_FS_FILENAME="rootfs.tar.gz"
wget -O ${ROOT_FS_FILENAME} http://build.syncloud.org:8111/guestAuth/repository/download/image_armv7l_rootfs/lastSuccessful/${ROOT_FS_FILENAME} --progress dot:giga

mkdir rootfs

tar xzf rootfs.tar.gz -C rootfs
cp -r build.sh rootfs/root
chroot rootfs root/build.sh