# Find all ".pyc" files
find . -name '*.pyc'
find . -name '*pycache*'

# Find and delete all ".pyc" files
# find . -name '*.pyc' -delete
# or....
# find . -name '*pycache*' -exec rm -rf {} \;

# -exec takes a command (a program that takes arguments, not a
# built-in shell command),

# `{}` is replaced with the filename from `find`

# The `;` tells -exec where to stop, but it needs to be escaped, so it
# is: `\;`

