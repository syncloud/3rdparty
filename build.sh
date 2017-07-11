#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}
export DEBIAN_FRONTEND=noninteractive
apt-get -qq update
apt-get -qqy install openssh-client wget dpkg-dev curl > /dev/null

PROJECT=$1
ARCH=$(uname -m)

cd ${DIR}/${PROJECT}
if [ -f deps.sh ]; then
    echo "deps"
    ./deps.sh
fi

echo "building"
./build.sh ${ARCH}
