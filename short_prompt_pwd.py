#!/usr/bin/python

import os
from commands import getoutput
from socket import gethostname
hostname = gethostname()
if len(hostname) > 11:
  hostname = hostname[:8] + '...' + hostname[-2:]
username = os.environ['USER']
pwd = os.getcwd()
homedir = os.path.expanduser('~')
pwd = pwd.replace(homedir, '~', 1)
if len(pwd) > 30:
    pwd = pwd[:10]+'...'+pwd[-20:]
print '[%s@%s:%s] ' % (username, hostname, pwd)
