#!/bin/bash
# 
yum -y install ceph-deploy
mkdir /ceph-deploy
cd /ceph-deploy/
ceph-deploy new ceph1 ceph2 ceph3 
ceph-deploy mon create-initial
