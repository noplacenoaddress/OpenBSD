#!/bin/ksh

<<<<<<< Updated upstream
=======
<<<<<<< HEAD
#https://dnsviz.net/d/dreamhost.com/dnssec/
#https://help.dreamhost.com/hc/es/articles/219539467-Generalidades-DNSSEC

=======
>>>>>>> master
>>>>>>> Stashed changes
DOMAIN=$1
ZONEDIR="/var/nsd/zones/master"
DNSSECDIR="/var/nsd/etc/dnssec"


<<<<<<< Updated upstream
if [[ $# -eq 0 ]];then
	print "No Arguments"
=======
<<<<<<< HEAD
[[ $# -eq 0 ]] && \
	print "No Arguments" && \
>>>>>>> Stashed changes
	exit
fi

if [[ $2 == "clean" ]];then
	rm $DNSSECDIR/*$DOMAIN*
	rm $ZONEDIR/$DOMAIN.zone.signed
	exit
fi

if [[ $2 == "reload" ]];then
	ZSK=$(basename $(grep -r "`grep '(zsk)' *.signed |cut -f3-10`" $DNSSECDIR/K$DOMAIN.*.key | cut -d ':' -f1) .key)
	KSK=$(basename $(grep -r "`grep '(ksk)' *.signed |cut -f3-10`" $DNSSECDIR/K$DOMAIN.*.key | cut -d ':' -f1) .key)

	ldns-signzone -n -p -s $(head -n 1000 /dev/random | sha1 | cut -b 1-16) -f $ZONEDIR/$DOMAIN.zone.signed $DOMAIN.zone $DNSSECDIR/$ZSK $DNSSECDIR/$KSK
	nsd-control reload $DOMAIN
	nsd-control notify $DOMAIN
	exit
<<<<<<< Updated upstream
fi
=======
=======
if [[ $# -eq 0 ]];then
	print "No Arguments"
	exit
fi

if [[ $2 == "clean" ]];then
	rm $DNSSECDIR/*$DOMAIN*
	rm $ZONEDIR/$DOMAIN.zone.signed
	exit
fi

if [[ $2 == "reload" ]];then
	ZSK=$(basename $(grep -r "`grep '(zsk)' *.signed |cut -f3-10`" $DNSSECDIR/K$DOMAIN.*.key | cut -d ':' -f1) .key)
	KSK=$(basename $(grep -r "`grep '(ksk)' *.signed |cut -f3-10`" $DNSSECDIR/K$DOMAIN.*.key | cut -d ':' -f1) .key)

	ldns-signzone -n -p -s $(head -n 1000 /dev/random | sha1 | cut -b 1-16) -f $ZONEDIR/$DOMAIN.zone.signed $DOMAIN.zone $DNSSECDIR/$ZSK $DNSSECDIR/$KSK
	nsd-control reload $DOMAIN
	nsd-control notify $DOMAIN
	exit
fi
>>>>>>> master
>>>>>>> Stashed changes

cd $ZONEDIR

export ZSK=`ldns-keygen -a RSASHA1-NSEC3-SHA1 -b 1024 $DOMAIN`
export KSK=`ldns-keygen -k -a RSASHA1-NSEC3-SHA1 -b 2048 $DOMAIN`

<<<<<<< Updated upstream
rm $ZSK.ds $KSK.ds
mv $ZSK.* $DNSSECDIR && mv $KSK.* $DNSSECDIR
chown root:_nsd $DNSSECDIR/* && chmod ug+r,o-rwx $DNSSECDIR/* 

=======
<<<<<<< HEAD
[[ -e $ZSK.ds ]] && rm $ZSK.ds 
[[ -e $KSK.ds ]] && rm $KSK.ds
mv $ZSK.* $DNSSECDIR && mv $KSK.* $DNSSECDIR
chown root:_nsd $DNSSECDIR/* && chmod ug+r,o-rwx $DNSSECDIR/* 

[[ $DOMAIN == "9-rg.com" ]] && DOMAIN="9rgcom"

=======
rm $ZSK.ds $KSK.ds
mv $ZSK.* $DNSSECDIR && mv $KSK.* $DNSSECDIR
chown root:_nsd $DNSSECDIR/* && chmod ug+r,o-rwx $DNSSECDIR/* 

>>>>>>> master
>>>>>>> Stashed changes
# now it's time to create the .signed zone file
ldns-signzone -n -p -s $(head -n 1000 /dev/random | sha1 | cut -b 1-16) -f $ZONEDIR/$DOMAIN.zone.signed $DOMAIN.zone $DNSSECDIR/$ZSK $DNSSECDIR/$KSK

# and here are our DS records to give to our registrar
ldns-key2ds -n -1 $DOMAIN.zone.signed && ldns-key2ds -n -2 $DOMAIN.zone.signed
