#!build/certbot/python/bin/python

from subprocess import check_call

check_call('build/certbot/bin/certbot --help all', shell=True)

check_call('build/certbot/bin/certbot plugins', shell=True)