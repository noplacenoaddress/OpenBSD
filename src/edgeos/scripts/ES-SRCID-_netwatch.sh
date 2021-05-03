#!/bin/bash

ROUTER_IP=10.10.10.254
IPSEC="telecomlobby-/SRCID/"
GRE="tun0"

PING_RESULT=$(/usr/bin/fping -I$GRE $ROUTER_IP 2>&1)
ALIVE="alive"
STATUS=$(/usr/sbin/ipsec status $IPSEC)
ESTABLISHED="INSTALLED"

if [[ "$PING_RESULT" != *"$ALIVE"* ]]; then
	/usr/sbin/ipsec stroke down-nb $IPSEC
	/usr/sbin/ipsec down $IPSEC
	/usr/sbin/ipsec up $IPSEC
fi 

