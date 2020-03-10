------------------------------
将主机名为proxy的主机配置为chrony服务器
Modify /etc/chrony.conf :

bindacqaddress 0.0.0.0
allow 0/0

并配置好ceph的yum源，检查yum源文件：file/ceph.repo

------------------------------
If need restart ceph services , this is the command:
systemctl restart ceph\*.service ceph\*.target 

------------------------------
本机的'id_rsa'密钥需要可以连接所有的ceph主机
