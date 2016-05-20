#!build/python/bin/python

from certbot import main
from certbot.plugins import disco as plugins_disco


print(plugins_disco.PluginsRegistry.find_all())
