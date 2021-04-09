#!/bin/ksh

OPTION=$1
$BACKUP="/root/Backups/ssl"

cp /home/taglio/Sources/Git/OpenBSD/src/etc/acme-client.conf /etc
cd /etc/ssl
case $OPTION in
	"b" )
		mv *telecomlobby* $BACKUP/
		mv private/*telecomlobby* $BACKUP/private/ 
		cp /etc/httpd.conf $BACKUP/ 
		cp /home/taglio/Sources/Git/OpenBSD/src/etc/httpd-nossl.conf /etc/httpd.conf
		httpd -n 
		rcctl restart httpd ;;
	"u" )
		mv $BACKUP/*telecomlobby* .
		mv $BACKUP/private/*telecomlobby* private/ 
		mv $BACKUP/httpd.conf /etc 
		httpd -n
		rcctl restart httpd ;;
	"c" )
		tar -cvf /root/$BACKUPs/ssl_backup.tar $BACKUP/
		rm -rf $BACKUP/*
		cp /home/taglio/Sources/Git/OpenBSD/src/etc/httpd.conf /etc/
		httpd -n
		rcctl restart httpd ;;
		
	* )
		print "use b, u or c"
		exit 1 ;;
esac

