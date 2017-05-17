#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

PROJECT=$1
if git diff-tree --name-only HEAD^..HEAD | grep ${PROJECT}; then
    echo "${PROJECT}: building"
    ${DIR}/${PROJECT}/build.sh $(uname -m)
    ${DIR}/tools/upload.sh ImageMagick-$(uname -m).tar.gz

else
    echo "${PROJECT} skipping, no changes in last commit"
fi