#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

./build/php/bin/php.sh -i
./build/php/bin/php.sh -i | grep -i svg
./build/php/bin/php.sh -i | grep -i smbclient
./build/php/bin/php.sh -i | grep -i imagemagick
./build/php/bin/php.sh -i | grep -i gd
./build/php/bin/php.sh -i | grep -i mysql
./build/php/bin/php.sh -i | grep -i postgresql
./build/php/bin/php.sh -i | grep -i ldap
./build/php/bin/php.sh -r "echo gethostbyname('apps.nextcloud.com');"
./build/php/bin/php.sh -r "echo gethostbyname('apps.nextcloud.com');" | grep -v apps.nextcloud.com