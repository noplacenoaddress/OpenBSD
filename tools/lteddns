#!/bin/ksh

unbound-control flush_zone mynetname.net ; pfctl -t lte -T kill ; pfctl -t lte -T add -f /etc/pf.conf.table.lte 
