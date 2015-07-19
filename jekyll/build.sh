#!/bin/bash -x


DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

ARCH=$(dpkg-architecture -qDEB_HOST_GNU_CPU)
if [ ! -z "$1" ]; then
    ARCH=$1
fi

if [ ! -d ${DIR}/3rdparty ]; then
    mkdir ${DIR}/3rdparty
fi
if [ ! -f ${DIR}/3rdparty/ruby.tar.gz ]; then
    wget http://build.syncloud.org:8111/guestAuth/repository/download/thirdparty_ruby_${ARCH}/lastSuccessful/ruby.tar.gz \
    -O ${DIR}/3rdparty/ruby.tar.gz --progress dot:giga
else
    echo "skipping ruby.tar.gz"
fi

export TMPDIR=/tmp
export TMP=/tmp
NAME=jekyll

rm -rf ${DIR}/build
mkdir ${DIR}/build

tar xzf ${DIR}/3rdparty/ruby.tar.gz -C ${DIR}/build
export GEM_HOME=${DIR}/build/ruby
export LD_LIBRARY_PATH=${DIR}/build/ruby/lib
${DIR}/build/ruby/bin/gem install -V --install-dir ${DIR}/build/ruby jekyll
${DIR}/build/ruby/bin/jekyll -v

rm -rf ${DIR}/${NAME}.tar.gz

tar cpzf ${DIR}/${NAME}.tar.gz -C ${DIR}/build ruby