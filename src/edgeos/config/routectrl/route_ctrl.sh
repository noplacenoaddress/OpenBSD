if [[ $# -eq 0 ]]; then
	echo -e $0 "have to be used with the following options \
			\n \
			\n-B   			-> boot geoip routing table populate [o]\
			\n-T [tunnel]	-> tunnel periodic check [o]\
			\n-P [tunnel]	-> pluto up/down [o]\
			\n-L 			-> loop to check tunnels are alive [o]\
			\n"
	exit 1
fi

case "$1" in
	"-B")
		sleep 30s
		for tun in $(/sbin/ip link | grep tun | awk '{print $2}' | sed "s|@.*||g"); do
			tunep=$(/sbin/ip link list dev "${tun}" | awk 'FNR == 2' | awk '{print $4}')
			phm=$(/sbin/ip link list dev "${tun}" | grep alias | awk '{print $2}')
			for group in "${groups[@]}"; do
				/sbin/ipset list "${group}" | grep "${tunep}" &> /dev/null
				if [ $? -eq 0 ]; then
					if [[ $(/sbin/ip route ls table "${group}" | grep "${tun}") == "" ]]; then
						metric=$(/bin/cat /config/routectrl/metric | grep "${phm}" | awk '{print $4}')
						if [[ "${metric}" -eq 0 && "${group}" -ne 43 ]]; then
							/sbin/ip route add table ${group} default nexthop dev ${tun}
						elif [[ "${metric}" -eq 0 && "${group}" -eq 43 ]]; then
							/sbin/ip route add table ${group} default dev ${tun} metric 1
						elif [[ "${metric}" -eq 1 && "${group}" -eq 43 ]]; then
							/sbin/ip route add table ${group} default nexthop dev ${tun}
						else
							/sbin/ip route add table ${group} default dev ${tun} metric ${metric}
						fi
					fi
				fi
			done
		done
	;;
	"-T")
		if [[ "${2}" =~ "^tun*[0-9]$" ]]; then
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
		echo "/usr/bin/fping -I${2} $peerlip"
		ping_result=$(/usr/bin/fping -I${2} $peerlip 2>&1)
		alive="alive"
		status=$(/usr/sbin/ipsec status $tunnelid)
		established="INSTALLED"

		if [[ "$ping_result" != *"$alive"* ]]; then
				/bin/ps axu | grep "$tunnelid\|CRON\|netwatch" | grep -v grep | grep -v $$ | awk '{print $2}' | xargs kill -9
				/usr/sbin/ipsec stroke down-nb $tunnelid
				/usr/sbin/ipsec down $tunnelid
				/usr/sbin/ipsec up $tunnelid
				sleep 60s
		fi
	;;
	"-P")
		if [[ "${2}" =~ "^tun*[0-9]$" ]]; then
			echo "pass tun interface device as argument"
			exit 1
		fi
		case "${PLUTO_VERB}" in
		        up-host|up-client)
		                /usr/bin/logger "Putting interface ${2} up"
		                /sbin/ip link set dev "${2}" up
		                /usr/bin/logger "Disabling IPsec policy (SPD) for ${2}"
		                /sbin/sysctl -w "net.ipv4.conf.${2}.disable_policy=1"
		                /usr/bin/logger "Accepting gre keepalive"
		                /sbin/sysctl -w "net.ipv4.conf.${2}.accept_local=1"
						tunep=$(/sbin/ip link list dev "${2}" | awk 'FNR == 2' | awk '{print $4}')
						phm=$(/sbin/ip link list dev "${2}" | grep alias | awk '{print $2}')
						for group in "${groups[@]}"; do
							/sbin/ipset list "${group}" | grep "${tunep}" &> /dev/null
							if [ $? -eq 0 ]; then
								if [[ $(/sbin/ip route ls table "${group}" | grep "${tun}") == "" ]]; then
									metric=$(/bin/cat /config/routectrl/metric | grep "${phm}" | awk '{print $4}')
									if [[ "${metric}" -eq 0 && "${group}" -ne 43 ]]; then
										/sbin/ip route add table ${group} default nexthop dev ${tun}
									elif [[ "${metric}" -eq 0 && "${group}" -eq 43 ]]; then
										/sbin/ip route add table ${group} default dev ${tun} metric 1
									elif [[ "${metric}" -eq 1 && "${group}" -eq 43 ]]; then
										/sbin/ip route add table ${group} default nexthop dev ${tun}
									else
										/sbin/ip route add table ${group} default dev ${tun} metric ${metric}
									fi
								fi
							fi
						done
		                ;;
		        down-host|down-client)
		               	/usr/bin/logger "${2} down"
		                /sbin/ip link set dev "${2}" down
		                ;;
		esac
	;;
	"-L")
		sleep 60s
		while true
		do
			for tun in $(/sbin/ip link | grep tun | awk '{print $2}' | sed "s|@.*||g"); do
				/config/routectrl/route_ctrl.sh -T "${tun}"
			done
		done
	;;
	*)
		/config/routectrl/route_ctrl.sh
	;;
esac
