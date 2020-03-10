安装前将两台主机的eth0网卡设置为manual模式，并为主配置好VIP（eth0:1）
安装完成以后需要手动配置mysql互为主从结构，执行命令：
change master to 和 slave start 
