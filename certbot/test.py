#!build/python/bin/python

from certbot import main
from certbot.plugins import disco as plugins_disco
from subprocess import check_call


print(plugins_disco.PluginsRegistry.find_all())

check_call('build/bin/certbot -h', shell=True)