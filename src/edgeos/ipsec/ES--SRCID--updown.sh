#!/bin/bash

set -o nounset
set -o errexit

<<<<<<< Updated upstream
TUN_IFACE="tun0"
BACKUP_ROUTE="tun3"
=======
<<<<<<< HEAD
TUN_IFACE="/TUN/"
PREFIX="/ROUTERIDLAST/"

ctrlinterface=$(/sbin/ip route ls table ${PREFIX} | grep ${TUN_IFACE})
/OTHERSTUN/
=======
TUN_IFACE="tun0"
BACKUP_ROUTE="tun3"
>>>>>>> master
>>>>>>> Stashed changes

case "${PLUTO_VERB}" in
	up-host)
		echo "Putting interface ${TUN_IFACE} up"
<<<<<<< Updated upstream
		ifconfig $TUN_IFACE up
		echo "Disabling IPsec policy (SPD) for ${TUN_IFACE}"
		sysctl -w "net.ipv4.conf.${TUN_IFACE}.disable_policy=1"
		echo "Accepting gre keepalive"
		sysctl -w "net.ipv4.conf.${TUN_IFACE}.accept_local=1"
		echo "Adding default route to table 3"
		ip route del table 2 default
		ip route add table 2 default nexthop dev ${TUN_IFACE}
		
=======
<<<<<<< HEAD
                /sbin/ifconfig $TUN_IFACE up
                echo "Disabling IPsec policy (SPD) for ${TUN_IFACE}"
                /sbin/sysctl -w "net.ipv4.conf.${TUN_IFACE}.disable_policy=1"
                echo "Accepting gre keepalive"
                /sbin/sysctl -w "net.ipv4.conf.${TUN_IFACE}.accept_local=1"
                /sbin/ip route del table ${PREFIX} default
                [[ $ctrlinterface == "" ]] && /sbin/ip route add table ${PREFIX} default nexthop dev ${TUN_IFACE}
               	/OTHERSTUN2/
>>>>>>> Stashed changes
		;;
	down-host)
		ifconfig $TUN_IFACE down
		ip route add table 2 default nexthop dev ${BACKUP_ROUTE}
		;;
esac
<<<<<<< Updated upstream

=======
=======
		ifconfig $TUN_IFACE up
		echo "Disabling IPsec policy (SPD) for ${TUN_IFACE}"
		sysctl -w "net.ipv4.conf.${TUN_IFACE}.disable_policy=1"
		echo "Accepting gre keepalive"
		sysctl -w "net.ipv4.conf.${TUN_IFACE}.accept_local=1"
		echo "Adding default route to table 3"
		ip route del table 2 default
		ip route add table 2 default nexthop dev ${TUN_IFACE}
		
		;;
	down-host)
		ifconfig $TUN_IFACE down
		ip route add table 2 default nexthop dev ${BACKUP_ROUTE}
		;;
esac

>>>>>>> master
>>>>>>> Stashed changes
