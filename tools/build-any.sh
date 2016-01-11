#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
else
    ARCH=$1
fi

HOST_ARCH=$(arch)

if [ "$ARCH" == "$HOST_ARCH" ]; then
  echo "same arch as host, running plain build"
  ./build.sh ${ARCH}
else
  echo "running chrooted build"
  ${DIR}/build-chroot.sh ${ARCH}
fi