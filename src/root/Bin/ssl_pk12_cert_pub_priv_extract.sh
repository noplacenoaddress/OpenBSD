#!/bin/ksh

if [[ $# -eq 0 ]];then
	print "No Arguments"
	exit
fi


openssl pkcs12 -in $1 -nocerts -out /etc/iked/private/local.key
cp /etc/iked/private/local.key /etc/isakmpd/private/local.key
openssl pkcs12 -in $1 -clcerts -nokeys -out /etc/iked/certs/$1.crt
cp /etc/iked/certs/$1.crt /etc/isakmpd/certs/
openssl x509 -pubkey -noout -in /etc/iked/certs/$1.crt  > /etc/iked/local.pub
cp /etc/iked/local.pub /etc/isakpmd/local.pub



