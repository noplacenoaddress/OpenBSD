#!/bin/ksh

ipsecctl -nf /etc/ipsec.conf
ipsecctl -F 
ipsecctl -f /etc/ipsec.conf

