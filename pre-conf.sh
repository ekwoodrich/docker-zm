#!/bin/bash

#fix problem relate to update mysql
echo "sql_mode = NO_ENGINE_SUBSTITUTION" >> /etc/mysql/mysql.conf.d/mysqld.cnf
cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/my.cnf
cp /etc/mysql/mysql.conf.d/mysqld.cnf /usr/my.cnf

mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld

#initial conf for mysql
mysql_install_db
#for configuriing database
/usr/bin/mysqld_safe &
sleep 10s

mysqladmin -u root password mysqlpsswd
mysqladmin -u root -pmysqlpsswd reload
mysqladmin -u root -pmysqlpsswd create zm

echo "grant select,insert,update,delete on zm.* to 'zmuser'@localhost identified by 'zmpass'; flush privileges; " | mysql -u root -pmysqlpsswd

DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y -q php7.0-gd zoneminder

mysql -u root -pmysqlpsswd < /usr/share/zoneminder/db/zm_create.sql
sleep 1s


mysql -u root -pmysqlpsswd -D zm -e "UPDATE Config SET Value = '/zm/cgi-bin/nph-zms' WHERE Name = 'ZM_PATH_ZMS';"
sleep 1s
mysql -u root -pmysqlpsswd -D zm -e "UPDATE Config SET Value = 1 WHERE Name = 'ZM_OPT_FFMPEG';"
sleep 1s
mysql -u root -pmysqlpsswd -D zm -e "UPDATE Config SET Value = '/usr/bin/ffmpeg' WHERE Name = 'ZM_PATH_FFMPEG';"

#to fix error relate to ip address of container apache2
echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf
ln -s /etc/apache2/conf-available/fqdn.conf /etc/apache2/conf-enabled/fqdn.conf

#apache2 conf
a2enmod cgi
a2enconf zoneminder
chown -R www-data:www-data /usr/share/zoneminder/
a2enmod rewrite
adduser www-data video

mkdir -p /usr/share/zoneminder/www/api/app/tmp/cache

mkdir -p /usr/share/zoneminder/www/api/app/tmp/cache/persistent
mkdir -p /usr/share/zoneminder/www/api/app/tmp/cache/models

chown -R www-data:www-data chown /usr/share/zoneminder/www/api/app/tmp
chmod -R 755 /usr/share/zoneminder/www/api/app/tmp/cache/persistent

#to clear some data before saving this layer ...a docker image
rm -R /var/www/html
rm /etc/apache2/sites-enabled/000-default.conf
apt-get clean
rm -rf /tmp/* /var/tmp/*
rm -rf /var/lib/apt/lists/*

killall mysqld
sleep 10s
