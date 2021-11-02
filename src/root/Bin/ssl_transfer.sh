#!/bin/ksh

if [[ $# -eq 0 ]];then
        print "No Arguments"
        exit
fi


CERT=$1

cd /etc/ssl
tar -cvf $CERT.tar $CERT.{crt,pem} private/$CERT.key
mv $CERT.tar /var/www/ganesha.telecom.lobby/

