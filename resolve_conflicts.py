#!/usr/bin/env python

import subprocess
import os

# List the unmerged files.
cwd = os.getcwd()
output = subprocess.check_output(
    ['git', 'diff',
     '--name-status',
     '--diff-filter=U',
     '--relative', cwd])

# Pull out each newline, and remove the starting 'U\t'.
lst = map(lambda w : w[2:], output.split('\n'))

print('Files with conflicts:')
for f in lst:
  print('  %s' % f)
print('Please merge using VIM. Commands: ')
print('  ct = Use theirs')
print('  co = Use ours')
print('  cb = Use both')
print('  cn = Use none')

for f in lst:
  if not f.isspace():
    print('Resolve conflicts in %s' % (f))
    subprocess.call(['vim', f])

print('All done! Please run "git commit -a"')
