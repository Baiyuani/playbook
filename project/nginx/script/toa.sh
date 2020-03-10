#!/bin/bash
# 
insmod /root/toa.ko

echo '
#!/bin/sh
/sbin/modinfo -F filename /root/toa.ko > /dev/null 2>&1
if [ $? -eq 0 ]; then
  /sbin/insmod /root/toa.ko
fi  ' > /etc/sysconfig/modules/toa.modules
chmod +x /etc/sysconfig/modules/toa.modules

