#!/bin/bash
# 
SERVER () {
	yum -y install gcc pcre-devel zlib-devel openssl-devel
	tar -xf /root/Zabbix/nginx-1.12.2.tar.gz 
	cd /root/Zabbix/nginx-1.12.2/
	./configure --with-http_ssl_module
	make -C /root/Zabbix/nginx-1.12.2/
	make install -C /root/Zabbix/nginx-1.12.2/
	yum -y install php php-fpm php-mysql 
	sed -ri "23i fastcgi_read_timeout 300;" /usr/local/nginx/conf/nginx.conf
	sed -ri "23i fastcgi_send_timeout 300;" /usr/local/nginx/conf/nginx.conf
	sed -ri "23i fastcgi_connect_timeout 300;" /usr/local/nginx/conf/nginx.conf
	sed -ri "23i fastcgi_buffer_size 32k;" /usr/local/nginx/conf/nginx.conf
	sed -ri "23i fastcgi_buffers 8 16k;" /usr/local/nginx/conf/nginx.conf
	sed -ri "/index/s/index\.html/index\.php/" /usr/local/nginx/conf/nginx.conf
	sed -ri "69,75s/#//" /usr/local/nginx/conf/nginx.conf
	sed -ri "73s/^/#/" /usr/local/nginx/conf/nginx.conf
	sed -ri "/fastcgi_params/s/_params/\.conf/" /usr/local/nginx/conf/nginx.conf
	systemctl start php-fpm 
	systemctl enable php-fpm 
	/usr/local/nginx/sbin/nginx
	echo "/usr/local/nginx/sbin/nginx" >> /etc/rc.local
	chmod +x /etc/rc.local
	yum -y install net-snmp-devel curl-devel libevent-devel
	tar -xf /root/Zabbix/zabbix-3.4.4.tar.gz -C /root
	cd /root/zabbix-3.4.4
	./configure --enable-server  --enable-proxy --enable-agent --with-mysql=/usr/bin/mysql_config --with-net-snmp --with-libcurl
	make install
	mysql -e "create database zabbix character set utf8;"
	mysql -e "grant all on zabbix.* to zabbix@'localhost' identified by 'zabbix';" 
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
	netstat -lntup |grep 10051
	sleep 3
}
AGENT () {
	read -p 'Input zabbix_server IP:' SIP
	read -p 'Input zabbix_server port:(if use default port then ENTER)' SPORT
	yum -y install gcc pcre-devel
	tar -xf /root/Zabbix/zabbix-3.4.4.tar.gz -C /root
	cd /root/zabbix-3.4.4
	./configure --enable-agent
	make install
	confa='/usr/local/etc/zabbix_agentd.conf'
	sed -ri '69s/#//' $confa
	sed -ri '69s/0/1/' $confa
	sed -ri "93s/$/,$SIP/" $confa
	sed -ri "134s/127.0.0.1/$SIP:${SPORT:-10051}/" $confa
	sed -ri '264s/#//' $confa
	sed -ri '280s/#//' $confa
	sed -ri '280s/0/1/' $confa
	useradd zabbix
	zabbix_agentd
	ss -lntup |grep 10050
	sleep 3
}

AGENTAC () {
	read -p 'Input zabbix_server IP:' SIP
	read -p 'Input zabbix_server port:(if use default port then ENTER)' SPORT
	yum -y install gcc pcre-devel
	tar -xf /root/Zabbix/zabbix-3.4.4.tar.gz -C /root
	cd /root/zabbix-3.4.4
	./configure --enable-agent
	make install
	confa='/usr/local/etc/zabbix_agentd.conf'
	sed -ri '69s/#//' $confa
	sed -ri '69s/0/1/' $confa
	sed -ri "93s/^/#/" $confa
	sed -ri "134s/127.0.0.1/$SIP:${SPORT:-10051}/" $confa
	sed -ri "145s/Zabbix server/$HOSTNAME/" $confa
	sed -ri '183s/#//' $confa
	sed -ri '118s/#//' $confa
	sed -ri '118s/3/0/' $confa
	sed -ri '264s/#//' $confa
	sed -ri '280s/#//' $confa
	sed -ri '280s/0/1/' $confa
	useradd zabbix
	zabbix_agentd
	sleep 0.5
	ps -C zabbix_agentd
	echo "

   Hostname is $HOSTNAME

"
}

echo "
Please Input Option:
1 -------> Install zabbix_server
2 -------> Install zabbix_agent 
3 -------> Install zabbix_agent(Active) " 
read INPUT
case $INPUT in 
1)
	SERVER
	;;
2)	
	AGENT
	;;
3)
	AGENTAC
	;;
*)
	echo "Input error!"
esac
