#!/bin/bash
# 初始化集群
mkdir /var/hadoop
cd /usr/local/hadoop/
./bin/hdfs namenode -format
# 启动服务
./sbin/start-dfs.sh
