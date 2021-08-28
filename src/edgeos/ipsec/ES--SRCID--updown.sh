#!/bin/bash

set -o nounset
set -o errexit

TUN_IFACE="/TUN/"
PREFIX="/ROUTERIDLAST/"

ctrlinterface=$(/sbin/ip route ls table ${PREFIX} | grep ${TUN_IFACE})
/OTHERSTUN/

case "${PLUTO_VERB}" in
	up-host)
		echo "Putting interface ${TUN_IFACE} up"
                /sbin/ifconfig $TUN_IFACE up
                echo "Disabling IPsec policy (SPD) for ${TUN_IFACE}"
                /sbin/sysctl -w "net.ipv4.conf.${TUN_IFACE}.disable_policy=1"
                echo "Accepting gre keepalive"
                /sbin/sysctl -w "net.ipv4.conf.${TUN_IFACE}.accept_local=1"
                /sbin/ip route del table ${PREFIX} default
                [[ $ctrlinterface == "" ]] && /sbin/ip route add table ${PREFIX} default nexthop dev ${TUN_IFACE}
               	/OTHERSTUN2/
		;;
	down-host)
		/sbin/ifconfig $TUN_IFACE down
;;
esac

