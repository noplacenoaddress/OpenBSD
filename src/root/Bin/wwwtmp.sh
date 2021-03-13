#!/bin/ksh

cp -R /home/taglio/wwwtmp/* /var/www/htdocs/telecomlobby.com

chown -R wwwftp:www /var/www/htdocs/telecomlobby.com
chmod -R o-rwx,g+r /var/www/htdocs/telecomlobby.com

