#!/bin/bash -x


DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

if [ ! -d ${DIR}/3rdparty ]; then
    mkdir ${DIR}/3rdparty
fi
if [ ! -f ${DIR}/3rdparty/ruby.tar.gz ]; then
    wget http://build.syncloud.org:8111/guestAuth/repository/download/thirdparty_ruby_${ARCH}/lastSuccessful/ruby-${ARCH}.tar.gz \
    -O ${DIR}/3rdparty/ruby.tar.gz --progress dot:giga
else
    echo "skipping ruby.tar.gz"
fi

export TMPDIR=/tmp
export TMP=/tmp
NAME=jekyll
export DEBIAN_FRONTEND=noninteractive
apt-get -y install build-essential nodejs

rm -rf ${DIR}/build
mkdir ${DIR}/build

tar xzf ${DIR}/3rdparty/ruby.tar.gz -C ${DIR}/build
export GEM_HOME=${DIR}/build/ruby
export LD_LIBRARY_PATH=${DIR}/build/ruby/lib
export PATH=${DIR}/build/ruby/bin:$PATH
${DIR}/build/ruby/bin/gem install -V --install-dir ${DIR}/build/ruby jekyll

mv ${DIR}/build/ruby ${DIR}/build/jekyll
mv ${DIR}/build/jekyll/bin/jekyll ${DIR}/build/jekyll/bin/jekyll.bin
cp ${DIR}/jekyll ${DIR}/build/jekyll/bin/jekyll
${DIR}/build/jekyll/bin/jekyll -v

rm -rf ${DIR}/${NAME}-${ARCH}.tar.gz
tar cpzf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${DIR}/build jekyll
