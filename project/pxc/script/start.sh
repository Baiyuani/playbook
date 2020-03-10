#!/bin/bash
if test $HOSTNAME == mysql1;then
	exit 0
else
	systemctl start mysql
	systemctl enable mysql 2>&1
fi
