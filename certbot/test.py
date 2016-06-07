#!build/certbot/python/bin/python

from subprocess import check_call
import shutil
from os.path import dirname, join

DIR = dirname(__file__)
BUILD_DIR = join(DIR, 'build')
ROOTFS_DIR = join(BUILD_DIR, 'rootfs')

shutil.copytree(join(BUILD_DIR, 'certbot'), ROOTFS_DIR)

check_call('chroot {0} certbot/bin/certbot --help all'.format(ROOTFS_DIR), shell=True)

check_call('chroot {0} certbot/bin/certbot plugins --logs-dir=. --config-dir=.'.format(ROOTFS_DIR), shell=True)
