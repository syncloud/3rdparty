#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

apt-get -qq update
apt-get -qqy install git openssh-client wget > /dev/null

PROJECT=$1
ARCH=$(uname -m)
if git diff-tree --name-only HEAD^..HEAD | grep ${PROJECT}; then
    echo "${PROJECT}: building"
    ${DIR}/${PROJECT}/build.sh ${ARCH}
    cd ${PROJECT}
    ${DIR}/tools/upload.sh ${PROJECT}-${ARCH}.tar.gz
else
    echo "${PROJECT} skipping, no changes in last commit"
fi