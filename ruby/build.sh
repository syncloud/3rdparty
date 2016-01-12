#!/bin/bash


DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

apt-get -y install dpkg-dev

ARCH=$1

export TMPDIR=/tmp
export TMP=/tmp
NAME=ruby
VERSION=2.1.5
PREFIX=${DIR}/build

echo "building ${NAME}"

command curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -

#useradd -p ruby ruby

rm -rf ${PREFIX}
mkdir ${PREFIX}

curl -sSL https://get.rvm.io | bash -s stable --path ${PREFIX}
source ${PREFIX}/scripts/rvm
rvm install ${VERSION} --movable

rm /etc/rvmrc
rm /etc/profile.d/rvm.sh

rm -rf ${DIR}/${NAME}.tar.gz

cp -r ${PREFIX}/rubies/${NAME}-${VERSION} ${PREFIX}/ruby

cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libyaml* ${PREFIX}/ruby/lib

rm -rf ${DIR}/${NAME}-${ARCH}.tar.gz
tar cpzf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${PREFIX} ${NAME}