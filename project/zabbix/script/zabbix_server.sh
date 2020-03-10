#!/bin/bash
# 
yum -y install gcc pcre-devel zlib-devel openssl-devel
cd /root/nginx-1.12.2/
./configure --with-http_ssl_module
make 
make install 
yum -y install php php-fpm php-mysql 
sed -ri "23i fastcgi_read_timeout 300;" /usr/local/nginx/conf/nginx.conf
sed -ri "23i fastcgi_send_timeout 300;" /usr/local/nginx/conf/nginx.conf
sed -ri "23i fastcgi_connect_timeout 300;" /usr/local/nginx/conf/nginx.conf
sed -ri "23i fastcgi_buffer_size 32k;" /usr/local/nginx/conf/nginx.conf
sed -ri "23i fastcgi_buffers 8 16k;" /usr/local/nginx/conf/nginx.conf
sed -ri "/index/s/index\.html/index\.php/" /usr/local/nginx/conf/nginx.conf
sed -ri "70,76s/#//" /usr/local/nginx/conf/nginx.conf
sed -ri "74s/^/#/" /usr/local/nginx/conf/nginx.conf
sed -ri "/fastcgi_params/s/_params/\.conf/" /usr/local/nginx/conf/nginx.conf
systemctl start php-fpm 
systemctl enable php-fpm 
/usr/local/nginx/sbin/nginx
echo "/usr/local/nginx/sbin/nginx" >> /etc/rc.local
chmod +x /etc/rc.local
cd /root/mysql/
yum -y install *
systemctl start mysqld
systemctl enable mysqld
PASS_MYSQL=$(grep root /var/log/mysqld.log | awk '{print $NF}')
mysql -uroot -p"${PASS_MYSQL}" -e "alter user root@localhost identified by '123qqq...A'" --connect-expired-password
mysql -uroot -p'123qqq...A' -e "create database zabbix character set utf8;"
mysql -uroot -p'123qqq...A' -e "set global validate_password_policy=0;"
mysql -uroot -p'123qqq...A' -e "set global validate_password_length=6;"
mysql -uroot -p'123qqq...A' -e "grant all on zabbix.* to zabbix@'localhost' identified by 'zabbix';" 
sed -ri '/\[mysqld\]/a validate_password_policy=0' /etc/my.cnf
sed -ri '/\[mysqld\]/a validate_password_length=6' /etc/my.cnf
SERVER_ID=$(ifconfig eth0 | grep 'net ' | awk '{print $2}' | awk -F[.] '{print $4}')
sed -ri "/\[mysqld\]/a server_id=${SERVER_ID}" /etc/my.cnf
sed -ri "/log_bin/s/# log_bin/log_bin=master${SERVER_ID}/" /etc/my.cnf
sed -ri '/\[mysqld\]/a binlog_format="mixed"' /etc/my.cnf
systemctl restart mysqld
mysql -uroot -p'123qqq...A' -e "grant replication slave on *.* to repluser@'%' identified by '123qqq...A';"

yum -y install net-snmp-devel curl-devel libevent-devel
cd /root/zabbix-3.4.4
./configure --enable-server  --enable-proxy --enable-agent --with-mysql=/usr/bin/mysql_config --with-net-snmp --with-libcurl
make install
cd /root/zabbix-3.4.4/database/mysql/
mysql -uzabbix -pzabbix zabbix < schema.sql 
mysql -uzabbix -pzabbix zabbix < images.sql 
mysql -uzabbix -pzabbix zabbix < data.sql
cp -a /root/zabbix-3.4.4/frontends/php/* /usr/local/nginx/html/
chmod -R 777 /usr/local/nginx/html/*
yum -y install php-gd php-xml php-ldap php-bcmath php-mbstring
sed -ri "878s/;//" /etc/php.ini
sed -ri '878s#$# Asia/Shanghai#' /etc/php.ini
sed -ri '672s/8M/32M/' /etc/php.ini
sed -ri '384s/$/0/' /etc/php.ini
sed -ri '394s/60/300/' /etc/php.ini
systemctl restart php-fpm
confd='/usr/local/etc/zabbix_server.conf'
sed -ri '85s/#//' $confd
sed -ri '119s/#//' $confd
sed -ri '119s/$/zabbix/' $confd
useradd zabbix
zabbix_server
echo zabbix_server >> /etc/rc.local
chmod +x /etc/rc.local
