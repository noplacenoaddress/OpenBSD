#!/bin/bash

ROUTER_IP=/GREPOPIP/
IPSEC="telecomlobby-/PUBLICHOSTNAME/"
GRE="/TUN/"

PING_RESULT=$(/usr/bin/fping -I$GRE $ROUTER_IP 2>&1)
ALIVE="alive"
STATUS=$(/usr/sbin/ipsec status $IPSEC)
ESTABLISHED="INSTALLED"

if [[ "$PING_RESULT" != *"$ALIVE"* ]]; then
<<<<<<< Updated upstream
=======
<<<<<<< HEAD
	/bin/ps axu | grep "$IPSEC\|CRON\|netwatch" | grep -v grep | grep -v $$ | awk '{print $2}' | xargs kill -9
=======
>>>>>>> master
>>>>>>> Stashed changes
	/usr/sbin/ipsec stroke down-nb $IPSEC
	/usr/sbin/ipsec down $IPSEC
	/usr/sbin/ipsec up $IPSEC
fi 

