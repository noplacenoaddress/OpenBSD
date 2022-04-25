#!/bin/ksh

let counter=1
while ((counter<5)); do
  ((counter=counter+1))
  /bin/sleep $((10-$(/bin/date +%s)%10))
  /usr/sbin/unbound-control flush_zone mynetname.net
  for ddns in $(cat /etc/pf.conf.table.lte | grep mynetname.net); do
      oldip=$(/usr/bin/dig A "${ddns}" +short)
      (( $(/sbin/pfctl -t lte -T show | grep -wc "${oldip}") == 0 )) && (
        [[ "${1}" = "iked" ]] && /usr/sbin/ikectl reload
        /sbin/pfctl -t lte -T kill
        /sbin/pfctl -t lte -T add -f /etc/pf.conf.table.lte
      )
  done
done
