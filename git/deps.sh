#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

apt-get update
apt-get -y install libcurl4-openssl-dev libexpat1-dev gettext libz-dev libssl-dev
apt-get -y install asciidoc xmlto docbook2x
apt-get -y install autoconf
