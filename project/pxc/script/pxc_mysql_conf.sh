#!/bin/bash
# Solve "server-id" question
sed -ri "/server-id/s/$/$(ifconfig eth0 | grep 'inet ' | awk '{print $2}' | awk -F[.] '{print $NF}')/" /etc/percona-xtradb-cluster.conf.d/mysqld.cnf
