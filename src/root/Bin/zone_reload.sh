#!/bin/ksh

if [[ $# -eq 0 ]];then
	print "No Arguments"
	exit
fi

DOMAIN=$1

nsd-control reload $DOMAIN
nsd-control notify $DOMAIN

