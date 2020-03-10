#!/bin/bash
yum -y install gcc pcre-devel
cd /root/zabbix-3.4.4
./configure --enable-agent
make install
confa='/usr/local/etc/zabbix_agentd.conf'
sed -ri '69s/#//' $confa
sed -ri '69s/0/1/' $confa
sed -ri "93s/^/#/" $confa
sed -ri "134s/127.0.0.1/192.168.1.222:10051/" $confa
sed -ri "145s/Zabbix server/$HOSTNAME/" $confa
sed -ri '183s/#//' $confa
sed -ri '118s/#//' $confa
sed -ri '118s/3/0/' $confa
sed -ri '264s/#//' $confa
sed -ri '280s/#//' $confa
sed -ri '280s/0/1/' $confa
useradd zabbix
zabbix_agentd
echo zabbix_agentd >> /etc/rc.local
chmod +x /etc/rc.local
