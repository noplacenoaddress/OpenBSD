#!/bin/ksh

if [[ $# -eq 0 ]];then
	print "No Arguments"
	exit
fi


CERT=$1

cd /etc/ssl
tar -cvf $CERT.tar $CERT.{crt,pem} private/$CERT.key
scp $CERT.tar taglio@shiva:/home/taglio
scp $CERT.tar taglio@saraswati:/home/taglio

