#!/bin/ksh

if [[ $# -eq 0 ]];then
	print "No Arguments"
	exit
fi

rcctl stop iked && nohup iked -f $1 -dvv > /root/ipsec_debug.txt &


