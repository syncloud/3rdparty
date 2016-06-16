#!build/certbot/python/bin/python

from subprocess import check_call
import shutil
from os.path import dirname, join
import os


DIR = dirname(__file__)
BUILD_DIR = join(DIR, 'build')
ROOTFS_DIR = join(BUILD_DIR, 'rootfs')

shutil.copytree(join(BUILD_DIR, 'certbot'), join(ROOTFS_DIR, 'certbot'))
os.environ['LD_LIBRARY_PATH'] ='certbot/python/lib'
prefix = 'chroot {0}'.format(ROOTFS_DIR)
check_call('{0} ldd certbot/python/lib/python2.7/lib-dynload/_ssl.so'.format(prefix), shell=True)

check_call('{0} certbot/bin/certbot --help all'.format(prefix), shell=True)

check_call('{0} certbot/bin/certbot plugins --logs-dir=. --config-dir=.'.format(prefix), shell=True)
