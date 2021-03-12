#!/bin/ksh

if [[ $# -eq 0 ]];then
	print "No Arguments"
	exit
fi

DOMAIN=$1
STRING=$(sed -e '1d' -e '$d' $DOMAIN | tr -d '\n')
echo "v=DKIM1; k=rsa; p=${STRING}"

