#!/bin/bash
#
ceph-deploy mds create ceph1
#rsync -av ceph1:/etc/ceph/* /etc/ceph/
ceph osd pool create cephfs_data 128
ceph osd pool create cephfs_metadata 128
ceph fs new myfs1 cephfs_metadata cephfs_data 
ceph -s
awk '/key/{print $3}' /etc/ceph/ceph.client.admin.keyring > file/ceph_key.txt
