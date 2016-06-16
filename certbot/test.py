#!build/certbot/python/bin/python

from subprocess import check_call
import shutil
from os.path import dirname, join

DIR = dirname(__file__)
BUILD_DIR = join(DIR, 'build')
ROOTFS_DIR = join(BUILD_DIR, 'rootfs')

shutil.copytree(join(BUILD_DIR, 'certbot'), join(ROOTFS_DIR, 'certbot'))
prefix = 'chroot {0} LD_LIBRARY_PATH=certbot/python/lib'.format(ROOTFS_DIR)
check_call('{0} ldd certbot/python/lib/python2.7/lib-dynload/_ssl.so'.format(prefix), shell=True)

check_call('{0} certbot/bin/certbot --help all'.format(prefix), shell=True)

check_call('{0} certbot/bin/certbot plugins --logs-dir=. --config-dir=.'.format(prefix), shell=True)
