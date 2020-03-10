#!/bin/bash
# You should create a directory to manage the ceph's cluster

for i in $(seq 3)
do 
	ssh ceph$i hostnamectl set-hostname ceph$i
done

pip uninstall urllib3 << EOF
y
EOF

for j in $(seq 3)
do 
	ssh ceph$j "pip uninstall urllib3 << EOF
y
EOF"
done

ansible-playbook ceph_part1.yml
yum -y install ceph-deploy ceph-mon ceph-osd ceph-mds
ceph-deploy new ceph1 ceph2 ceph3
ceph-deploy mon create-initial

for k in $(seq 3)
do
    ssh ceph$k "parted /dev/vdb mklabel gpt"
    ssh ceph$k "parted /dev/vdb mkpart primary 1 50%"
    ssh ceph$k "parted /dev/vdb mkpart primary 50% 100%"
done
ansible-playbook ceph_part2.yml
ceph-deploy disk zap ceph1:vdc ceph1:vdd ceph2:vdc ceph2:vdd ceph3:vdc ceph3:vdd
ceph-deploy osd create ceph1:vdc:/dev/vdb1 ceph1:vdd:/dev/vdb2 ceph2:vdc:/dev/vdb1 ceph2:vdd:/dev/vdb2 ceph3:vdc:/dev/vdb1 ceph3:vdd:/dev/vdb2     
# If need restart ceph services , this is the command:
# systemctl restart ceph\*.service ceph\*.target    

ceph-deploy mds create ceph1
rsync -av ceph1:/etc/ceph/* /etc/ceph/
ceph osd pool create cephfs_data 128
ceph osd pool create cephfs_metadata 128
ceph fs new myfs1 cephfs_metadata cephfs_data 
ceph -s
awk '/key/{print $3}' /etc/ceph/ceph.client.admin.keyring > file/ceph_key.txt
