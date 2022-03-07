#!/usr/bin/bash

#VyOS route ctrl



function netwatch () {
	ROUTER_IP=10.10.10.197
	IPSEC="telecomlobby-BG"
	gre="${1}"
	peer=$(/sbin/ip link show dev "${gre}" | grep alias | awk '{print $2}')
	phm=$(echo "${peer}" | cut -d . -f1)
	typeset -u upphm="${phm}"
	tunnelid="telecomlobby-${upphm}"


	PING_RESULT=$(/usr/bin/fping -I$GRE $ROUTER_IP 2>&1)
	ALIVE="alive"
	STATUS=$(/usr/sbin/ipsec status $IPSEC)
	ESTABLISHED="INSTALLED"

	if [[ "$PING_RESULT" != *"$ALIVE"* ]]; then
	        /bin/ps axu | grep "$IPSEC\|CRON\|netwatch" | grep -v grep | grep -v $$ | awk '{print $2}' | xargs kill -9
	        /usr/sbin/ipsec stroke down-nb $IPSEC
	        /usr/sbin/ipsec down $IPSEC
	        /usr/sbin/ipsec up $IPSEC
	fi

}

function pluto () {
	TUN_IFACE="tun6"
	PREFIX=61

	case "${PLUTO_VERB}" in
	        up-host|up-client)
	                /usr/bin/logger "Putting interface ${TUN_IFACE} up"
	                /sbin/ip link set dev "${TUN_IFACE}" up
	                /usr/bin/logger "Disabling IPsec policy (SPD) for ${TUN_IFACE}"
	                /sbin/sysctl -w "net.ipv4.conf.${TUN_IFACE}.disable_policy=1"
	                /usr/bin/logger "Accepting gre keepalive"
	                /sbin/sysctl -w "net.ipv4.conf.${TUN_IFACE}.accept_local=1"
	                /sbin/ip route add table $PREFIX default nexthop dev "${TUN_IFACE}"
	                /sbin/ip route add table 1 metric 7 scope link default nexthop dev "${TUN_IFACE}"
	                /sbin/ip route add table 19 metric 7 scope link default nexthop dev "${TUN_IFACE}"
	                /sbin/ip route add table 33 metric 7 scope link default nexthop dev "${TUN_IFACE}"
	                /sbin/ip route add table 44 metric 7 scope link default nexthop dev "${TUN_IFACE}"
	                /sbin/ip route add table 49 metric 7 scope link default nexthop dev "${TUN_IFACE}"
	                /sbin/ip route add table 59 metric 7 scope link default nexthop dev "${TUN_IFACE}"
	                /sbin/ip route add table 81 metric 7 scope link default nexthop dev "${TUN_IFACE}"
	                /sbin/ip route add table 91 metric 7 scope link default nexthop dev "${TUN_IFACE}"
	                ;;
	        down-host|down-client)
	                logger "${TUN_IFACE} down"
	                /sbin/ip link set dev "${TUN_IFACE}" down
	                ;;
	esac
}

function geoloc () {
	
}

if [[ $# -eq 0 ]]; then
	echo -e $0 "have to be used with the following options \
			\n \
			\n-B   		-> boot geoip routing table populate [o]\
			\n-T tunnel	-> tunnel periodic check [o]\
			\n"
	exit 1
fi

case "$1" in
	"-B")

		ctrltable12=$(/sbin/ip route ls table 12)
		ctrltable34=$(/sbin/ip route ls table 34)
		ctrltable56=$(/sbin/ip route ls table 56)

		[[ $ctrltable12 == "" ]] && \
			PREFIX=12 && \
			/sbin/ip route add table ${PREFIX} default nexthop dev tun1 && \
			/sbin/ip route add table ${PREFIX} metric 1 default nexthop dev tun0 && \
			/sbin/ip route add table ${PREFIX} metric 2 default nexthop dev tun2 && \
			/sbin/ip route add table ${PREFIX} metric 3 default nexthop dev tun3 && \
			/sbin/ip route add table ${PREFIX} metric 4 default nexthop dev tun4 && \
			/sbin/ip route add table ${PREFIX} metric 5 default nexthop dev tun5 && \
			/sbin/ip route add table ${PREFIX} metric 6 default nexthop dev tun6 || \
			PREFIX=1 && \
			ctrltun0=$(/sbin/ip route ls table ${PREFIX} | grep tun0) && \
			ctrltun1=$(/sbin/ip route ls table ${PREFIX} | grep tun1) && \
			ctrltun2=$(/sbin/ip route ls table ${PREFIX} | grep tun2) && \
			ctrltun3=$(/sbin/ip route ls table ${PREFIX} | grep tun3) && \
			ctrltun4=$(/sbin/ip route ls table ${PREFIX} | grep tun4) && \
			ctrltun5=$(/sbin/ip route ls table ${PREFIX} | grep tun5) && \
			ctrltun6=$(/sbin/ip route ls table ${PREFIX} | grep tun6) && \
			if [[ $ctrltun0 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 1 default nexthop dev tun0
			fi && \
			if [[ $ctrltun1 == "" ]]; then
				/sbin/ip route add table ${PREFIX} default nexthop dev tun1
			fi && \
			if [[ $ctrltun2 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 2 default nexthop dev tun2
			fi && \
			if [[ $ctrltun3 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 3 default nexthop dev tun3
			fi && \
			if [[ $ctrltun4 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 4 default nexthop dev tun4
			fi && \
			if [[ $ctrltun5 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 5 default nexthop dev tun5
			fi && \
			if [[ $ctrltun6 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 6 default nexthop dev tun6
			fi

		[[ $ctrltable33 == "" ]] && \
			PREFIX=33 && \
			/sbin/ip route add table ${PREFIX} default nexthop dev tun0 && \
			/sbin/ip route add table ${PREFIX} metric 1 default nexthop dev tun1 && \
			/sbin/ip route add table ${PREFIX} metric 2 default nexthop dev tun2 && \
			/sbin/ip route add table ${PREFIX} metric 3 default nexthop dev tun3 && \
			/sbin/ip route add table ${PREFIX} metric 4 default nexthop dev tun4 && \
			/sbin/ip route add table ${PREFIX} metric 5 default nexthop dev tun5 && \
			/sbin/ip route add table ${PREFIX} metric 6 default nexthop dev tun6 || \
			PREFIX=33 && \
			ctrltun0=$(/sbin/ip route ls table ${PREFIX} | grep tun0) && \
			ctrltun1=$(/sbin/ip route ls table ${PREFIX} | grep tun1) && \
			ctrltun2=$(/sbin/ip route ls table ${PREFIX} | grep tun2) && \
			ctrltun3=$(/sbin/ip route ls table ${PREFIX} | grep tun3) && \
			ctrltun4=$(/sbin/ip route ls table ${PREFIX} | grep tun4) && \
			ctrltun5=$(/sbin/ip route ls table ${PREFIX} | grep tun5) && \
			ctrltun6=$(/sbin/ip route ls table ${PREFIX} | grep tun6) && \
			if [[ $ctrltun0 == "" ]]; then
				/sbin/ip route add table ${PREFIX} default nexthop dev tun0
			fi && \
			if [[ $ctrltun1 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 1 default nexthop dev tun1
			fi && \
			if [[ $ctrltun2 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 2 default nexthop dev tun2
			fi && \
			if [[ $ctrltun3 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 3 default nexthop dev tun3
			fi && \
			if [[ $ctrltun4 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 4 default nexthop dev tun4
			fi && \
			if [[ $ctrltun5 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 5 default nexthop dev tun5
			fi && \
			if [[ $ctrltun6 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 6 default nexthop dev tun6
			fi

		[[ $ctrltable44 == "" ]] && \
			PREFIX=44 && \
			/sbin/ip route add table ${PREFIX} default nexthop dev tun3 && \
			/sbin/ip route add table ${PREFIX} metric 1 default nexthop dev tun0 && \
			/sbin/ip route add table ${PREFIX} metric 2 default nexthop dev tun1 && \
			/sbin/ip route add table ${PREFIX} metric 3 default nexthop dev tun2 && \
			/sbin/ip route add table ${PREFIX} metric 4 default nexthop dev tun4 && \
			/sbin/ip route add table ${PREFIX} metric 5 default nexthop dev tun5 && \
			/sbin/ip route add table ${PREFIX} metric 6 default nexthop dev tun6 || \
			PREFIX=44 && \
			ctrltun0=$(/sbin/ip route ls table ${PREFIX} | grep tun0) && \
			ctrltun1=$(/sbin/ip route ls table ${PREFIX} | grep tun1) && \
			ctrltun2=$(/sbin/ip route ls table ${PREFIX} | grep tun2) && \
			ctrltun3=$(/sbin/ip route ls table ${PREFIX} | grep tun3) && \
			ctrltun4=$(/sbin/ip route ls table ${PREFIX} | grep tun4) && \
			ctrltun5=$(/sbin/ip route ls table ${PREFIX} | grep tun5) && \
			ctrltun6=$(/sbin/ip route ls table ${PREFIX} | grep tun6) && \
			if [[ $ctrltun0 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 1 default nexthop dev tun0
			fi && \
			if [[ $ctrltun1 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 2 default nexthop dev tun1
			fi && \
			if [[ $ctrltun2 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 3 default nexthop dev tun2
			fi && \
			if [[ $ctrltun3 == "" ]]; then
				/sbin/ip route add table ${PREFIX} default nexthop dev tun3
			fi && \
			if [[ $ctrltun4 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 4 default nexthop dev tun4
			fi && \
			if [[ $ctrltun5 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 5 default nexthop dev tun5
			fi && \
			if [[ $ctrltun6 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 6 default nexthop dev tun6
			fi

		[[ $ctrltable49 == "" ]] && \
			PREFIX=49 && \
			/sbin/ip route add table ${PREFIX} default nexthop dev tun5 && \
			/sbin/ip route add table ${PREFIX} metric 1 default nexthop dev tun0 && \
			/sbin/ip route add table ${PREFIX} metric 2 default nexthop dev tun1 && \
			/sbin/ip route add table ${PREFIX} metric 3 default nexthop dev tun2 && \
			/sbin/ip route add table ${PREFIX} metric 4 default nexthop dev tun3 && \
			/sbin/ip route add table ${PREFIX} metric 5 default nexthop dev tun4 && \
			/sbin/ip route add table ${PREFIX} metric 6 default nexthop dev tun6 || \
			PREFIX=49 && \
			ctrltun0=$(/sbin/ip route ls table ${PREFIX} | grep tun0) && \
			ctrltun1=$(/sbin/ip route ls table ${PREFIX} | grep tun1) && \
			ctrltun2=$(/sbin/ip route ls table ${PREFIX} | grep tun2) && \
			ctrltun3=$(/sbin/ip route ls table ${PREFIX} | grep tun3) && \
			ctrltun4=$(/sbin/ip route ls table ${PREFIX} | grep tun4) && \
			ctrltun5=$(/sbin/ip route ls table ${PREFIX} | grep tun5) && \
			ctrltun6=$(/sbin/ip route ls table ${PREFIX} | grep tun6) && \
			if [[ $ctrltun0 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 1 default nexthop dev tun0
			fi && \
			if [[ $ctrltun1 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 2 default nexthop dev tun1
			fi && \
			if [[ $ctrltun2 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 3 default nexthop dev tun2
			fi && \
			if [[ $ctrltun3 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 4 default nexthop dev tun3
			fi && \
			if [[ $ctrltun4 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 5 default nexthop dev tun4
			fi && \
			if [[ $ctrltun5 == "" ]]; then
				/sbin/ip route add table ${PREFIX} default nexthop dev tun5
			fi && \
			if [[ $ctrltun6 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 6 default nexthop dev tun6
			fi


		[[ $ctrltable59 == "" ]] && \
			PREFIX=59 && \
			/sbin/ip route add table ${PREFIX} default nexthop dev tun4 && \
			/sbin/ip route add table ${PREFIX} metric 1 default nexthop dev tun0 && \
			/sbin/ip route add table ${PREFIX} metric 2 default nexthop dev tun1 && \
			/sbin/ip route add table ${PREFIX} metric 3 default nexthop dev tun2 && \
			/sbin/ip route add table ${PREFIX} metric 4 default nexthop dev tun3 && \
			/sbin/ip route add table ${PREFIX} metric 5 default nexthop dev tun5 && \
			/sbin/ip route add table ${PREFIX} metric 6 default nexthop dev tun6 || \
			PREFIX=59 && \
			ctrltun0=$(/sbin/ip route ls table ${PREFIX} | grep tun0) && \
			ctrltun1=$(/sbin/ip route ls table ${PREFIX} | grep tun1) && \
			ctrltun2=$(/sbin/ip route ls table ${PREFIX} | grep tun2) && \
			ctrltun3=$(/sbin/ip route ls table ${PREFIX} | grep tun3) && \
			ctrltun4=$(/sbin/ip route ls table ${PREFIX} | grep tun4) && \
			ctrltun5=$(/sbin/ip route ls table ${PREFIX} | grep tun5) && \
			ctrltun6=$(/sbin/ip route ls table ${PREFIX} | grep tun6) && \
			if [[ $ctrltun0 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 1 default nexthop dev tun0
			fi && \
			if [[ $ctrltun1 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 2 default nexthop dev tun1
			fi && \
			if [[ $ctrltun2 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 3 default nexthop dev tun2
			fi && \
			if [[ $ctrltun3 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 4 default nexthop dev tun3
			fi && \
			if [[ $ctrltun4 == "" ]]; then
				/sbin/ip route add table ${PREFIX} default nexthop dev tun4
			fi && \
			if [[ $ctrltun5 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 5 default nexthop dev tun5
			fi && \
			if [[ $ctrltun6 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 6 default nexthop dev tun6
			fi

		[[ $ctrltable61 == "" ]] && \
			PREFIX=61 && \
			/sbin/ip route add table ${PREFIX} default nexthop dev tun6 && \
			/sbin/ip route add table ${PREFIX} metric 1 default nexthop dev tun0 && \
			/sbin/ip route add table ${PREFIX} metric 2 default nexthop dev tun1 && \
			/sbin/ip route add table ${PREFIX} metric 3 default nexthop dev tun2 && \
			/sbin/ip route add table ${PREFIX} metric 4 default nexthop dev tun3 && \
			/sbin/ip route add table ${PREFIX} metric 5 default nexthop dev tun4 && \
			/sbin/ip route add table ${PREFIX} metric 6 default nexthop dev tun5 || \
			PREFIX=61 && \
			ctrltun0=$(/sbin/ip route ls table ${PREFIX} | grep tun0) && \
			ctrltun1=$(/sbin/ip route ls table ${PREFIX} | grep tun1) && \
			ctrltun2=$(/sbin/ip route ls table ${PREFIX} | grep tun2) && \
			ctrltun3=$(/sbin/ip route ls table ${PREFIX} | grep tun3) && \
			ctrltun4=$(/sbin/ip route ls table ${PREFIX} | grep tun4) && \
			ctrltun5=$(/sbin/ip route ls table ${PREFIX} | grep tun5) && \
			ctrltun6=$(/sbin/ip route ls table ${PREFIX} | grep tun6) && \
			if [[ $ctrltun0 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 1 default nexthop dev tun0
			fi && \
			if [[ $ctrltun1 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 2 default nexthop dev tun1
			fi && \
			if [[ $ctrltun2 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 3 default nexthop dev tun2
			fi && \
			if [[ $ctrltun3 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 4 default nexthop dev tun3
			fi && \
			if [[ $ctrltun4 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 5 default nexthop dev tun4
			fi && \
			if [[ $ctrltun5 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 6 default nexthop dev tun5
			fi && \
			if [[ $ctrltun6 == "" ]]; then
				/sbin/ip route add table ${PREFIX} default nexthop dev tun6
			fi

		[[ $ctrltable81 == "" ]] && \
			PREFIX=81 && \
			/sbin/ip route add table ${PREFIX} default nexthop dev tun2 && \
			/sbin/ip route add table ${PREFIX} metric 1 default nexthop dev tun0 && \
			/sbin/ip route add table ${PREFIX} metric 2 default nexthop dev tun1 && \
			/sbin/ip route add table ${PREFIX} metric 3 default nexthop dev tun3 && \
			/sbin/ip route add table ${PREFIX} metric 4 default nexthop dev tun4 && \
			/sbin/ip route add table ${PREFIX} metric 5 default nexthop dev tun5 && \
			/sbin/ip route add table ${PREFIX} metric 6 default nexthop dev tun6 || \
			PREFIX=81 && \
			ctrltun0=$(/sbin/ip route ls table ${PREFIX} | grep tun0) && \
			ctrltun1=$(/sbin/ip route ls table ${PREFIX} | grep tun1) && \
			ctrltun2=$(/sbin/ip route ls table ${PREFIX} | grep tun2) && \
			ctrltun3=$(/sbin/ip route ls table ${PREFIX} | grep tun3) && \
			ctrltun4=$(/sbin/ip route ls table ${PREFIX} | grep tun4) && \
			ctrltun5=$(/sbin/ip route ls table ${PREFIX} | grep tun5) && \
			ctrltun6=$(/sbin/ip route ls table ${PREFIX} | grep tun6) && \
			if [[ $ctrltun0 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 1 default nexthop dev tun0
			fi && \
			if [[ $ctrltun1 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 2 default nexthop dev tun1
			fi && \
			if [[ $ctrltun2 == "" ]]; then
				/sbin/ip route add table ${PREFIX} default nexthop dev tun2
			fi && \
			if [[ $ctrltun3 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 3 default nexthop dev tun3
			fi && \
			if [[ $ctrltun4 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 4 default nexthop dev tun4
			fi && \
			if [[ $ctrltun5 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 5 default nexthop dev tun5
			fi && \
			if [[ $ctrltun6 == "" ]]; then
				/sbin/ip route add table ${PREFIX} metric 6 default nexthop dev tun6
			fi

		[[ $ctrltable91 == "" ]] && \
		        PREFIX=91 && \
		        /sbin/ip route add table ${PREFIX} default nexthop dev tun7 && \
		        /sbin/ip route add table ${PREFIX} metric 1 default nexthop dev tun0 && \
		        /sbin/ip route add table ${PREFIX} metric 2 default nexthop dev tun1 && \
			/sbin/ip route add table ${PREFIX} metric 3 default nexthop dev tun2 && \
		        /sbin/ip route add table ${PREFIX} metric 4 default nexthop dev tun3 && \
		        /sbin/ip route add table ${PREFIX} metric 5 default nexthop dev tun4 && \
		        /sbin/ip route add table ${PREFIX} metric 6 default nexthop dev tun5 && \
		        /sbin/ip route add table ${PREFIX} metric 7 default nexthop dev tun6 || \
		        PREFIX=91 && \
		        ctrltun0=$(/sbin/ip route ls table ${PREFIX} | grep tun0) && \
		        ctrltun1=$(/sbin/ip route ls table ${PREFIX} | grep tun1) && \
		        ctrltun2=$(/sbin/ip route ls table ${PREFIX} | grep tun2) && \
		        ctrltun3=$(/sbin/ip route ls table ${PREFIX} | grep tun3) && \
		        ctrltun4=$(/sbin/ip route ls table ${PREFIX} | grep tun4) && \
		        ctrltun5=$(/sbin/ip route ls table ${PREFIX} | grep tun5) && \
		        ctrltun6=$(/sbin/ip route ls table ${PREFIX} | grep tun6) && \
			ctrltun7=$(/sbin/ip route ls table ${PREFIX} | grep tun7) && \
		        if [[ $ctrltun0 == "" ]]; then
		                /sbin/ip route add table ${PREFIX} metric 1 default nexthop dev tun0
		        fi && \
		        if [[ $ctrltun1 == "" ]]; then
		                /sbin/ip route add table ${PREFIX} metric 2 default nexthop dev tun1
		        fi && \
		        if [[ $ctrltun2 == "" ]]; then
		                /sbin/ip route add table ${PREFIX} default nexthop dev tun2
		        fi && \
		        if [[ $ctrltun3 == "" ]]; then
		                /sbin/ip route add table ${PREFIX} metric 3 default nexthop dev tun3
		        fi && \
		        if [[ $ctrltun4 == "" ]]; then
		                /sbin/ip route add table ${PREFIX} metric 4 default nexthop dev tun4
		        fi && \
		        if [[ $ctrltun5 == "" ]]; then
		                /sbin/ip route add table ${PREFIX} metric 5 default nexthop dev tun5
		        fi && \
		        if [[ $ctrltun6 == "" ]]; then
		                /sbin/ip route add table ${PREFIX} metric 6 default nexthop dev tun6
		        fi && \
		        if [[ $ctrltun7 == "" ]]; then
		                /sbin/ip route add table ${PREFIX} metric 7 default nexthop dev tun7
		        fi

	;;
	"-T")
	;;
	*)
		./$0
	;;
esac
