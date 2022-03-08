#!/usr/bin/bash

#VyOS route ctrl

declare -a groups=("12" "34" "56")

if [[ $# -eq 0 ]]; then
	echo -e $0 "have to be used with the following options \
			\n \
			\n-B   			-> boot geoip routing table populate [o]\
			\n-T [tunnel]	-> tunnel periodic check [o]\
			\n-P [tunnel]	-> pluto up/down [o]\
			\n"
	exit 1
fi

case "$1" in
	"-B")
		for tun in $(/sbin/ip link | grep tun | awk '{print $2}' | sed "s|@.*||g"); do
			tunep=$(/sbin/ip link list dev "${tun}" | awk 'FNR == 2' | awk '{print $4}')
			phm=$(/sbin/ip link list dev "${tun}" | grep alias | awk '{print $2}')
			for group in "${groups[@]}"; do
				/sbin/ipset list "${group}" | grep "${tunep}" &> /dev/null
				if [ $? -eq 0 ]; then
					if [[ $(/sbin/ip route ls table "${group}") == "" ]]; then
						/sbin/ip route add table "${group}" default nexthop dev "${tun}"
					else
						if [[ $(/sbin/ip route ls table "${group}" | grep "${tun}") == "" ]]; then
							metric=$(/bin/cat /config/routectrl/metric | grep "${phm}" | awk '{print $4}')
							/sbin/ip route add table "${group}" dev "${tun}" scope link metric "${metric}"
						fi
					fi
				fi
			done
		done
	;;
	"-T")
		if [[ "${2}" != "tun*[0-9]" ]]; then
			echo "pass tun interface device as argument"
			exit 1
		fi
		peer=$(/sbin/ip link show dev "${2}" | grep alias | awk '{print $2}')
		phm=$(echo "${peer}" | cut -d . -f1)
		typeset -u upphm="${phm}"
		tunnelid="telecomlobby-${upphm}"
		grelip=$(/sbin/ip addr show dev "${2}" | grep -w inet | awk '{print $2}' | sed "s|/.*$||")
		greliplo=$(echo "${grelip}" | cut -d . -f4)
		grebrdiplo=$(/sbin/ip addr show dev "${2}" | grep -w inet | awk '{print $4}' | cut -d . -f4)
		(( grebrdiplo-greliplo==2 )) && ((peerliplo = grebrdiplo - 1)) || ((peerliplo = grebrdiplo - 2))
		peerlip=$(echo "${grelip}" | sed "s|${greliplo}|${peerliplo}|")
		ping_result=$(/usr/bin/fping -I${2} $peerlip 2>&1)
		alive="alive"
		status=$(/usr/sbin/ipsec status $tunnelid)
		established="INSTALLED"

		if [[ "$ping_result" != *"$alive"* ]]; then
				/bin/ps axu | grep "$ipsec\|CRON\|netwatch" | grep -v grep | grep -v $$ | awk '{print $2}' | xargs kill -9
				/usr/sbin/ipsec stroke down-nb $ipsec
				/usr/sbin/ipsec down $ipsec
				/usr/sbin/ipsec up $ipsec
		fi
	"-P")
		if [[ "${2}" != "tun*[0-9]" ]]; then
			echo "pass tun interface device as argument"
			exit 1
		fi
		tunep=$(/sbin/ip link list dev "${2}" | awk 'FNR == 2' | awk '{print $4}')
		phm=$(/sbin/ip link list dev "${2}" | grep alias | awk '{print $2}')
		case "${PLUTO_VERB}" in
		        up-host|up-client)
		                /usr/bin/logger "Putting interface ${2} up"
		                /sbin/ip link set dev "${2}" up
		                /usr/bin/logger "Disabling IPsec policy (SPD) for ${2}"
		                /sbin/sysctl -w "net.ipv4.conf.${2}.disable_policy=1"
		                /usr/bin/logger "Accepting gre keepalive"
		                /sbin/sysctl -w "net.ipv4.conf.${2}.accept_local=1"
						for group in "${groups[@]}"; do
							/sbin/ipset list "${group}" | grep "${tunep}" &> /dev/null
							if [ $? -eq 0 ]; then
								metric=$(/bin/cat /config/routectrl/metric | grep "${phm}" | awk '{print $4}')
								/sbin/ip route add table "${group}" dev "${tun}" scope link metric "${metric}"
							fi
						done
		                ;;
		        down-host|down-client)
		               	/usr/bin/logger "${tun} down"
		                /sbin/ip link set dev "${tun}" down
		                ;;
		esac
	;;

	*)
		./$0
	;;
esac
