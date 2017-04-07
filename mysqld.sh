#!/bin/sh
### In mysqld.sh (make sure this file is chmod +x):
# `/sbin/setuser` runs the given command as the user `mysql`.
# If you omit that part, the command will be run as root.

exec /sbin/setuser mysql /usr/bin/mysqld_safe 2>&1 
