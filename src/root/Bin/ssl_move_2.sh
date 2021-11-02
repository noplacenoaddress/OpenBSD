#!/bin/ksh

OPTION=$1
if [[ -z $2 ]]; then
	STATE=$2
fi

cd /etc/ssl

case $OPTION in
	"b" )
		cp /etc/httpd.conf backup/
		if [[ -z $STATE ]]; then
			case $STATE in
				"us" )
					;;
				"jp")
					;;
				* )
					print "country not allowed"
					exit 1 ;;
			esac
		else 
			cp /home/taglio/Sources/Git/OpenBSD/src/etc/httpd-nossl.conf /etc/httpd.conf
		fi
		mv *telecomlobby* backup/
		mv *redama* backup/
		mv private/*telecomlobby* backup/private/ 
		mv private/*redama* backup/private/
		httpd -n 
		rcctl restart httpd
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
		print "use b, u or c & complementary country if necessary"
		exit 1 ;;
esac

