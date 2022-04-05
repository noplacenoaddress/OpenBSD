#!/bin/ksh

let counter=1
while ((counter<5)); do
  ((counter=counter+1))
  /bin/sleep $((10-$(/bin/date +%s)%10))
  /usr/sbin/unbound-control flush_zone mynetname.net ; /sbin/pfctl -t lte -T kill ; /sbin/pfctl -t lte -T add -f /etc/pf.conf.table.lte
done
