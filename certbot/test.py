#!build/python/bin/python

from subprocess import check_call

check_call('build/bin/certbot -h', shell=True)

check_call('build/bin/certbot -h certonly', shell=True)

check_call('build/bin/certbot -h install', shell=True)

check_call('build/bin/certbot plugins', shell=True)