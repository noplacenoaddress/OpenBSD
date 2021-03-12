#!/bin/ksh

if [[ $# -eq 0 ]];then
	print "No Arguments"
	exit
fi

openssl x509 -in $1 -text -noout



