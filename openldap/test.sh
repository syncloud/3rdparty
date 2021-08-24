#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

${DIR}/build/openldap/sbin/slapadd.sh --help || true
${DIR}/build/openldap/bin/ldapadd.sh --help || true
${DIR}/build/openldap/sbin/slapd.sh -V || true

rm -rf ${DIR}/build/slapd.d
rm -rf ${DIR}/build/data

mkdir ${DIR}/build/slapd.d
mkdir ${DIR}/build/data

sed -i "s#@ETC_DIR@#${DIR}/build/openldap/etc/ldap#g" ${DIR}/slapd.test.config.ldif
sed -i "s#@LIB_DIR@#${DIR}/build/openldap/usr/lib/ldap#g" ${DIR}/slapd.test.config.ldif
sed -i "s#@DB_DIR@#${DIR}/build/data#g" ${DIR}/slapd.test.config.ldif
${DIR}/build/openldap/sbin/slapadd.sh -v -F ${DIR}/build/slapd.d -n 0 -l ${DIR}/slapd.test.config.ldif
${DIR}/build/openldap/sbin/slapadd.sh -v -F ${DIR}/build/slapd.d -l ${DIR}/slapd.test.db.ldif
