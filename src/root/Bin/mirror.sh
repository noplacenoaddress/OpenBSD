#!/bin/ksh

if [[ $# -eq 0 ]];then
	print "No Arguments"
	exit
fi

DOMAIN=$1
wget --mirror --convert-links --adjust-extension --page-requisites  --no-parent  $DOMAIN


