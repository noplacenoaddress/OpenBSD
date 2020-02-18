#!/bin/ksh

HOST=$1
DOMAIN=$2

if [[ $# -eq 0]];then
  print "use $0 [host] [domain]"
  exit
fi

echo $HOST.$DOMAIN > /etc/myname

mkdir ~/Bin ~/Sources ~/Sources/Git ~/Download

pkg_add nano colorls wget
wget https://raw.githubusercontent.com/redeltaglio/OpenBSD/master/root.nanorc -O /root/.nanorc
cat /etc/examples/doas.conf | sed s/keepenv/"persist keepenv"/ > /etc/doas.conf
wget 
