#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

find $DIR/build/php -name "*magick*.so"

echo "extension_dir=\"$(echo $DIR/build/php/usr/local/lib/php/extensions/*)\"" > php.ini
cat php.ini 

./build/php/bin/php.sh -c php.ini -i
./build/php/bin/php.sh -c php.ini -i | grep -i svg
./build/php/bin/php.sh -c php.ini -i | grep -i smbclient
./build/php/bin/php.sh -c php.ini -i | grep -i imagemagick
./build/php/bin/php.sh -c php.ini -i | grep -i gd
./build/php/bin/php.sh -c php.ini -i | grep -i mysql
./build/php/bin/php.sh -c php.ini -i | grep -i postgresql
./build/php/bin/php.sh -c php.ini -i | grep -i ldap
./build/php/bin/php.sh -c php.ini -r "echo gethostbyname('apps.nextcloud.com');"
./build/php/bin/php.sh -c php.ini -r "echo gethostbyname('apps.nextcloud.com');" | grep -v apps.nextcloud.com
