#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

NAME=gogs
ARCH=$(dpkg-architecture -q DEB_HOST_GNU_CPU)

tar cpzf ${NAME}-${ARCH}.tar.gz -C ${BUILD_DIR} ${NAME}
