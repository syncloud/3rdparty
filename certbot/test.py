#!build/python/bin/python

from subprocess import check_call

check_call('build/bin/certbot --help all, shell=True)

check_call('build/bin/certbot plugins', shell=True)