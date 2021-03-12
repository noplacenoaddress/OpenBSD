#!/bin/ksh

rm -rf /etc/iked
mkdir -p /etc/iked/{ca,certs,crls,export,private,pubkeys}
mkdir -p /etc/iked/pubkeys/{ipv4,ipv6,fqdn,ufqdn}
chmod 750 /etc/iked

