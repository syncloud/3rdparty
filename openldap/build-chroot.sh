#!/bin/bash

ROOT_FS_FILENAME="rootfs.tar.gz"
wget -O ${ROOT_FS_FILENAME} http://build.syncloud.org:8111/repository/download/image_armv7l_rootfs/lastSuccessful/${ROOT_FS_FILENAME}

tar xzf rootfs.tar.gz
cp -r ./* rootfs/root
chroot rootfs root/build.sh