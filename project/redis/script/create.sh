#!/bin/bash
redis-trib.rb create --replicas 1  192.168.1.190:6379 192.168.1.191:6379 192.168.1.192:6379 192.168.1.193:6379 192.168.1.194:6379 192.168.1.195:6379 << EOF 
yes
EOF