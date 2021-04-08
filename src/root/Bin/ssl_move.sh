#!/bin/ksh

OPTION=$1

cd /etc/ssl
case $OPTION in
	"b" )
		mv *telecomlobby* backup/
		mv private/*telecomlobby* backup/private/ ;;
	"u" )
		mv backup/*telecomlobby* .
		mv backup/private/*telecomlobby* private/ ;;
	* )
		print "use b or u"
		exit 1 ;;
esac


