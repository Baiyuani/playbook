#!/bin/bash
#
cd /ceph-deploy/
ceph-deploy mds create ceph1
ceph osd pool create cephfs_data 128
ceph osd pool create cephfs_metadata 128
ceph fs new myfs1 cephfs_metadata cephfs_data
awk '/key/{print $3}' /etc/ceph/ceph.client.admin.keyring > /ceph_key.txt
scp /ceph_key.txt root@proxy:/root/project/nginx/file/
