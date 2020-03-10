#!/bin/bash
# 
cd /ceph-deploy/
ceph-deploy disk zap ceph1:vdc ceph1:vdd ceph2:vdc ceph2:vdd ceph3:vdc ceph3:vdd
ceph-deploy osd create ceph1:vdc:/dev/vdb1 ceph1:vdd:/dev/vdb2 ceph2:vdc:/dev/vdb1 ceph2:vdd:/dev/vdb2 ceph3:vdc:/dev/vdb1 ceph3:vdd:/dev/vdb2
# If need restart ceph services , this is the command:
# systemctl restart ceph\*.service ceph\*.target   
