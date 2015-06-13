#!/bin/bash


DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

export TMPDIR=/tmp
export TMP=/tmp
NAME=ruby
VERSION=2.1.5
ROOT=/opt/app/platform
PREFIX=${ROOT}/${NAME}

echo "building ${NAME}"

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

curl -sSL https://get.rvm.io | bash -s stable --ruby=${VERSION}

rm -rf ${NAME}.tar.gz
tar cpzf ${NAME}.tar.gz -C  ~/.rvm/rubies ${NAME}-${VERSION}