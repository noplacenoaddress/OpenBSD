#!/bin/ksh

DOMAIN=$1
ZONEDIR="/var/nsd/zones/master"
DNSSECDIR="/var/nsd/etc/dnssec"


[[ $# -eq 0 ]] && \
	print "No Arguments" && \
	exit


[[ $2 == "clean" ]] && \
	rm $DNSSECDIR/*$DOMAIN* && \
	rm $ZONEDIR/$DOMAIN.zone.signed && \
	exit
	
[[ $1 == "cleanall" ]] && \
	rm -rf $DNSSECDIR/* && \
	rm -rf $ZONEDIR/*.signed && \
	exit

[[ $2 == "reload" ]] && \
	ZSK=$(basename $(grep -r "`grep '(zsk)' *.signed |cut -f3-10`" $DNSSECDIR/K$DOMAIN.*.key | cut -d ':' -f1) .key) && \
	KSK=$(basename $(grep -r "`grep '(ksk)' *.signed |cut -f3-10`" $DNSSECDIR/K$DOMAIN.*.key | cut -d ':' -f1) .key) && \
	[[ $DOMAIN == "9-rg.com" ]] && DOMAIN="9rgcom" && \
	ldns-signzone -n -p -s $(head -n 1000 /dev/random | sha1 | cut -b 1-16) -f $ZONEDIR/$DOMAIN.zone.signed $DOMAIN.zone $DNSSECDIR/$ZSK $DNSSECDIR/$KSK && \
	[[ $DOMAIN == "9rgcom" ]] && DOMAIN="9-rg.com" && \
	nsd-control reload $DOMAIN && \
	nsd-control notify $DOMAIN && \
	exit

cd $ZONEDIR

export ZSK=`ldns-keygen -a RSASHA1-NSEC3-SHA1 -b 1024 $DOMAIN`
export KSK=`ldns-keygen -k -a RSASHA1-NSEC3-SHA1 -b 2048 $DOMAIN`

[[ -e $ZSK.ds ]] && rm $ZSK.ds 
[[ -e $KSK.ds ]] && rm $KSK.ds
mv $ZSK.* $DNSSECDIR && mv $KSK.* $DNSSECDIR
chown root:_nsd $DNSSECDIR/* && chmod ug+r,o-rwx $DNSSECDIR/* 

[[ $DOMAIN == "9-rg.com" ]] && DOMAIN="9rgcom"

# now it's time to create the .signed zone file
ldns-signzone -n -p -s $(head -n 1000 /dev/random | sha1 | cut -b 1-16) -f $ZONEDIR/$DOMAIN.zone.signed $DOMAIN.zone $DNSSECDIR/$ZSK $DNSSECDIR/$KSK

# and here are our DS records to give to our registrar
ldns-key2ds -n -1 $DOMAIN.zone.signed && ldns-key2ds -n -2 $DOMAIN.zone.signed
