#!/bin/bash
#-L </dev/null &>/dev/null &


declare -a groups=("12" "34" "43" "56")

# initialize a semaphore with a given number of tokens
open_sem(){
    mkfifo pipe-$$
    exec 3<>pipe-$$
    rm pipe-$$
    local i=$1
    for((;i>0;i--)); do
        printf %s 000 >&3
    done
}

# run the given command asynchronously and pop/push tokens
run_with_lock(){
    local x
    # this read waits until there is something to read
    read -u 3 -n 3 x && ((0==x)) || exit $x
    (
     ( "$@"; )
    # push the return code of the command to the semaphore
    printf '%.3d'  $? >&3
    )&
}


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
		for tun in $(/sbin/ip link | grep tun | grep -v tun[7,8] | awk '{print $2}' | sed "s|@.*||g"); do
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
		ping_result=$(nice -n 20 chrt -i 0 ionice -c3 /usr/bin/fping -I${2} $peerlip 2>&1)
		alive="alive"
		#status=$(/usr/sbin/ipsec status $tunnelid)
		established="INSTALLED"
		tunep=$(/sbin/ip link list dev "${2}" | awk 'FNR == 2' | awk '{print $4}')

		if [[ "$ping_result" != *"$alive"* ]]; then
				/bin/ps axu | grep "$tunnelid\|CRON\|netwatch" | grep -v grep | grep -v $$ | awk '{print $2}' | xargs kill -9
				/usr/sbin/ipsec stroke down-nb $tunnelid
				/usr/sbin/ipsec down $tunnelid
				./timeout 20 /usr/sbin/ipsec up $tunnelid
		else
			for group in "${groups[@]}"; do
				/sbin/ipset list "${group}" | grep "${tunep}" &> /dev/null
				if [ $? -eq 0 ]; then
					if [[ $(/sbin/ip route ls table "${group}" | grep "${2}") == "" ]]; then
						metric=$(/bin/cat /config/routectrl/metric | grep "${peer}" | awk '{print $4}')
						if [[ "${metric}" -eq 0 && "${group}" -ne 43 ]]; then
							/sbin/ip route add table ${group} default nexthop dev ${2}
						elif [[ "${metric}" -eq 0 && "${group}" -eq 43 ]]; then
							/sbin/ip route add table ${group} default dev ${2} metric 1
						elif [[ "${metric}" -eq 1 && "${group}" -eq 43 ]]; then
							/sbin/ip route add table ${group} default nexthop dev ${2}
						else
							/sbin/ip route add table ${group} default dev ${2} metric ${metric}
						fi
					fi
				fi
			done
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
		#sleep 60s
		n=2
		open_sem $n
		while true
		do
            for tunid in $(/sbin/ip link | grep tun | grep -v tun[7,8] | awk '{print $2}' | sed "s|@.*||g" | sed "s|tun||g"); do
        		for rid in "${rids[@]}"; do
        			[ "${tunid}" = $(echo $rid | cut -d \; -f2) ] && (
        				/sbin/ip route | grep 192.168.13.$(echo $rid | cut -d \; -f1) | grep tun$tunid
        				[ $? -eq 1 ] && (
        					for group in "${groups[@]}"; do
        						/sbin/ip route ls table "${group}" | grep tun$tunid
        						[ $? -eq 0 ] && /sbin/ip route del table "${group}" default dev tun$tunid
                            done
        				)
        			)
        		done

        	done
            for tunid in $(/sbin/ip link | grep tun | grep -v tun[7,8] | awk '{print $2}' | sed "s|@.*||g" | sed "s|tun||g"); do
                [[ $(ps axu | grep timeout | grep tun$tunid | wc -l) == 0 ]] && ./timeout -s9 25 /config/routectrl/route_ctrl.sh -T tun$tunid
            done
		done
	;;
	*)
		/config/routectrl/route_ctrl.sh
	;;
esac
