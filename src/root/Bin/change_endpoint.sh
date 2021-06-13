#!/bin/ksh

NEWIP=$(dig +short @8.8.8.8 cat-01.hopto.org)
OLDIP=$(ifconfig $1 | grep tunnel | cut -d ' ' -f5)

echo "updating PF"
sed -i "s/$OLDIP/$NEWIP/g" /etc/pf.conf.table.ipsec
pfctl -f /etc/pf.conf
echo "updating IKED"
sed -i "s/$OLDIP/$NEWIP/g" /etc/iked.conf.RT-01.cat.telecomlobby.com
rcctl restart iked
echo "updating GRE"
sed -i "s/$OLDIP/$NEWIP/g" /etc/hostname.gre1
ifconfig gre1 destroy
sh /etc/netstart $1

