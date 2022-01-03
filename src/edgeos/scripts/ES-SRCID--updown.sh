#!/bin/bash

set -o nounset
set -o errexit

TUN_IFACE="/TUN/"
PREFIX="/ROUTERIDLAST/"

case "${PLUTO_VERB}" in
	up-host|up-client)
		/usr/bin/logger "Putting interface ${TUN_IFACE} up"
		/sbin/ip link set dev "${TUN_IFACE}" up
		/usr/bin/logger "Disabling IPsec policy (SPD) for ${TUN_IFACE}"
		/sbin/sysctl -w "net.ipv4.conf.${TUN_IFACE}.disable_policy=1"
		/usr/bin/logger "Accepting gre keepalive"
		/sbin/sysctl -w "net.ipv4.conf.${TUN_IFACE}.accept_local=1"
		/sbin/ip route add table $PREFIX scope link default nexthop dev "${TUN_IFACE}"
/OTHERS/
		;;
	down-host|down-client)
		logger "${TUN_IFACE} down"
		/sbin/ip link set dev "${TUN_IFACE}" down
		;;
esac
