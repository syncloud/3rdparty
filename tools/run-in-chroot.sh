#!/bin/bash -xe

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

ARCH=$1
ROOTFS=rootfs
#ARCH=$(dpkg-architecture -q DEB_HOST_GNU_CPU)

if [ ! -f rootfs-${ARCH}.tar.gz ]; then
  wget http://build.syncloud.org:8111/guestAuth/repository/download/debian_rootfs_syncloud_${ARCH}/lastSuccessful/rootfs.tar.gz\
  -O rootfs-${ARCH}.tar.gz --progress dot:giga
else
  echo "skipping rootfs"
fi

function cleanup {
    mount | grep rootfs
    mount | grep rootfs | awk '{print "umounting "$1; system("umount "$3)}'
    mount | grep rootfs
    
    lsof 2>&1 | grep rootfs
    
    rm -rf ${ROOTFS}
}


cleanup || true

echo "extracting rootfs"
mkdir -p ${ROOTFS}
tar xzf rootfs-${ARCH}.tar.gz -C ${ROOTFS}
mkdir ${ROOTFS}/build

if [ -f deps.sh ]; then
    cp deps.sh ${ROOTFS}/build/
    chroot ${ROOTFS} /build/deps.sh
fi

cp build.sh ${ROOTFS}/build/
chroot ${ROOTFS} /build/build.sh ${ARCH}

cp ${ROOTFS}/build/*.tar.gz .
