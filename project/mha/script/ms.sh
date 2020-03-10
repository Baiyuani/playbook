#!/bin/bash
PASS_MYSQL=$(grep root /var/log/mysqld.log | awk '{print $NF}')
mysql -uroot -p"${PASS_MYSQL}" -e "alter user root@localhost identified by '123qqq...A'" --connect-expired-password
mysql -uroot -p'123qqq...A' -e "grant replication slave on *.* to repluser@'%' identified by '123qqq...A';"
mysql -uroot -p'123qqq...A' -e "grant all on *.* to root@'%' identified by '123qqq...A';"


if test $HOSTNAME == mysql1 ; then
	exit 0
else
	mysql -uroot -p'123qqq...A' -e "change master to master_host='192.168.1.180', master_user='repluser', master_password='123qqq...A', master_log_file='master180.000002', master_log_pos=965;"
	mysql -uroot -p'123qqq...A' -e "start slave;"
fi
