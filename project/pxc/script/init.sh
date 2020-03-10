#!/bin/bash
systemctl start mysql@bootstrap.service 
PASS_MYSQL=$(grep root /var/log/mysqld.log | awk '{print $NF}')
mysql -uroot -p"${PASS_MYSQL}" -e "alter user root@localhost identified by '123qqq...A'" --connect-expired-password
mysql -uroot -p'123qqq...A' -e 'grant reload,lock tables,replication client,process on *.* to sstuser@localhost identified by "123qqq...A"'
mysql -uroot -p'123qqq...A' -e "grant all on wordpress.* to wordpress@'%' identified by 'wordpress'"
systemctl enable mysql 2>&1
