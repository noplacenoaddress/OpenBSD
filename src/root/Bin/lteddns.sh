#!/bin/ksh

let counter=1
while ((counter<5)); do
  ((counter=counter+1))
  sleep $((10-$(date +%s)%10))
  unbound-control flush_zone mynetname.net ; pfctl -t lte -T kill ; pfctl -t lte -T add -f /etc/pf.conf.table.lte
done
