#!/bin/ksh

 zcat /var/www/logs/access.log.*.gz |  cat /var/www/logs/access.log - | cat /var/www/logs/telecomlobby.com-access.log - | \
	grep -v 172.16 | grep -v syslog | grep -v Css | grep -v Images | grep -v telecomlobby | grep -v 9-rg | \
	/usr/local/bin/goaccess - --no-global-config -o /var/www/htdocs/redama.es/report.html
