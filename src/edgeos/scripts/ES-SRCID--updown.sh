#!/bin/bash

set -o nounset
set -o errexit

TUN_IFACE="/TUN/"
<<<<<<< Updated upstream
=======
<<<<<<< HEAD
PREFIX="/ROUTERIDLAST/"
>>>>>>> Stashed changes

case "${PLUTO_VERB}" in
	up-host)
		echo "Putting interface ${TUN_IFACE} up"
		ifconfig $TUN_IFACE up
		echo "Disabling IPsec policy (SPD) for ${TUN_IFACE}"
		sysctl -w "net.ipv4.conf.${TUN_IFACE}.disable_policy=1"
		echo "Accepting gre keepalive"
		sysctl -w "net.ipv4.conf.${TUN_IFACE}.accept_local=1"
		;;
	down-host)
		ifconfig $TUN_IFACE down
		;;
esac
<<<<<<< Updated upstream

=======
=======

case "${PLUTO_VERB}" in
	up-host)
		echo "Putting interface ${TUN_IFACE} up"
		ifconfig $TUN_IFACE up
		echo "Disabling IPsec policy (SPD) for ${TUN_IFACE}"
		sysctl -w "net.ipv4.conf.${TUN_IFACE}.disable_policy=1"
		echo "Accepting gre keepalive"
		sysctl -w "net.ipv4.conf.${TUN_IFACE}.accept_local=1"
		;;
	down-host)
		ifconfig $TUN_IFACE down
		;;
esac

>>>>>>> master
>>>>>>> Stashed changes
