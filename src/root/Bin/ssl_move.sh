#!/bin/ksh

OPTION=$1

cd /etc/ssl
case $OPTION in
	"b" )
		mv *telecomlobby* backup/
		mv *redama* backup/
		mv private/*telecomlobby* backup/private/ 
		mv private/*redama* backup/private/
		cp /etc/httpd.conf backup/ 
		cp /home/taglio/Sources/Git/OpenBSD/src/etc/httpd-nossl.conf /etc/httpd.conf
		httpd -n 
		rcctl restart httpd ;;
	"u" )
		mv backup/*telecomlobby* .
		mv backup/*redama* .
		mv backup/private/*telecomlobby* private/ 
		mv backup/private/*redama* private/
		mv backup/httpd.conf /etc 
		httpd -n
		rcctl restart httpd ;;
	"c" )
		tar -cvf /root/Backups/ssl_backup.tar backup/
		rm -rf backup/*
		cp /home/taglio/Sources/Git/OpenBSD/src/etc/httpd.conf /etc/
		httpd -n
		rcctl restart httpd ;;
		
	* )
		print "use b, u or c"
		exit 1 ;;
esac

