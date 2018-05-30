#!/bin/sh
echo ============================================================
echo install lnmp
echo ===================================
echo install epel
yum -y install epel-release
echo install webtatic
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
echo update system
yum -y update
echo ===================================

echo ===================================
echo install php
yum -y install php71w-gd php71w-pdo php71w-opcache php71w-fpm php71w-pecl-redis php71w-mysql php71w-mcrypt php71w-mbstring php71w-intl php71w-cli
echo ===================================

echo ===================================
echo install nginx
yum -y install nginx
echo enable and start nginx and php-fpm
systemctl enable nginx php-fpm
systemctl start nginx php-fpm
echo setup nginx, wordpress path is /www/wordpress
cp -f ./nginx.conf /etc/nginx/
cp -f ./wordpress.conf /etc/nginx/conf.d/
systemctl restart nginx php-fpm
echo set iptables for fastcgi port: 9000
iptables -A INPUT -p tcp --dport 9000 -j ACCEPT
service iptables save
echo ===================================

echo ===================================
echo install mariadb
yum -y install mariadb mariadb-server
echo enable and start mariadb
systemctl enable mariadb
systemctl start mariabd
echo set mariadb password
mysqladmin -u root password 'mightyang1985'
echo create wordpress database
mysqladmin -uroot -pmightyang1985 create wordpress
echo ===================================
echo install lnmp finshed
echo ============================================================

echo ============================================================
echo install wordpress
echo install wget
yum -y install wget
echo install unzip
yum -y install unzip
echo download wordpress
wget http://wordpress.org/latest.zip
echo unzip latest.zip
unzip ./latest.zip
echo remove latest.zip
rm -f ./latest.zip
echo make path /www
mkdir -p /www
echo move wordpress to www
mv -rf ./wordpress /www/
echo change mod for www
chmod -R 777 /www
echo install wordpress finished
echo ============================================================
