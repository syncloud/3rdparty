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

apt-get -y install dpkg-dev

command curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -

#useradd -p ruby ruby

rm -rf /tmp/rvm

curl -sSL https://get.rvm.io | bash -s stable --path /tmp/rvm
source /tmp/rvm/scripts/rvm
rvm install ${VERSION}
rm -rf ${DIR}/${NAME}.tar.gz

rm -rd ${DIR}/build
mkdir ${DIR}/build

cp -r /tmp/rvm/rubies/${NAME}-${VERSION} ${DIR}/build/ruby

cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libyaml* ${DIR}/build/ruby/lib

tar cpzf ${DIR}/${NAME}.tar.gz -C ${DIR}/build ruby