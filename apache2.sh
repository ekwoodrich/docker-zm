#!/bin/sh
### In apache2.sh (make sure this file is chmod +x):
# `/sbin/setuser www-data` runs the given command as the user `www-data`.
# If you omit that part, the command will be run as root.

sv -w4 check mysqld

#read pid cmd state ppid pgrp session tty_nr tpgid rest < /proc/self/stat
#trap "kill -TERM -$pgrp; exit" EXIT TERM KILL SIGKILL SIGTERM SIGQUIT

source /etc/apache2/envvars
exec /sbin/setuser root apache2ctl -D FOREGROUND 2>&1  
