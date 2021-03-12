#!/bin/ksh

if [[ $# -eq 0 ]];then
	print "No Arguments"
	exit
fi

DOMAIN=$1

ping -c 1 $DOMAIN > /dev/null

