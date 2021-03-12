#!/bin/ksh

if [[ $# -eq 0 ]];then
	print "No Arguments"
	exit
fi


openssl rsa -in $1 -out $2


