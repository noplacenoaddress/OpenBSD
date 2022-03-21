#!/usr/bin/bash

# tr '[:lower:]' '[:upper:]' <<< ${a:0:1}


function passcheck () {
	z=$(timeout  --preserve-status 5 ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "${userna}"@"${1}" exit)
	echo $?
}

function capa3 () {
	case "${2}" in
		"wan")
			ping -c 1 "${1}" &> /dev/null && echo 1 || echo 0
		;;
		"mesh")
			[[ $(sshpass -p "${3}" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 admin@${3} :put \([/ping count=1 address="${1}"]=1\) | tail -n 1) == *"true"* ]] && echo 1 || echo 0
		;;
	esac
}

function typeofvar () {

    local type_signature=$(declare -p "$1" 2>/dev/null)

    if [[ "$type_signature" =~ "declare --" ]]; then
        printf "string"
    elif [[ "$type_signature" =~ "declare -a" ]]; then
        printf "array"
    elif [[ "$type_signature" =~ "declare -A" ]]; then
        printf "map"
    else
        printf "none"
    fi

}

function tempfile () {
    local TF="${1}"
    [[ -e "${RD}" ]] || mkdir "${RD}"
    for t in $(ls "${RD}"/console-* | grep -v "${TODAY}"); do srm "${t}" ; done
    touch "${RD}"/console-${TODAY}-${RANDOM}
    echo $_
}

function dnsquery () {

	case $(typeofvar $1) in
		"array")
			declare -n arr="${1}"
			case "${2}" in
				"-FL")
					r=$(tempfile)
					dig openbsd."${LDN}" TXT +short > "${r}"
                    dig raspi."${LDN}" TXT +short >> "${r}"
					dig mikrotik."${LDN}" TXT +short >> "${r}"
					dig edgeos."${LDN}" TXT +short >> "${r}"
					for lh in $(cat "${r}" | sed "s/\"//g" | tr \; '\n' | sed '$d'); do
						arr+=("${lh}")
					done
					srm "${r}"
				;;
				"-FP")
					for ph in $(dig ipsec20591."${PDN}" TXT +short @8.8.8.8 | sed "s/\"//g" | tr \; '\n' | sed '$d' | cut -d : -f1); do
						arr+=("${ph}")
					done
				;;
				*)
					for lh in $(dig "${2}"."${LDN}" TXT +short | sed "s/\"//g" | tr \; '\n' | sed '$d'); do
						arr+=("${lh}")
					done
				;;
			esac
		;;
		"none")
			case "${1}" in
				"-M")
					for ph in $(dig ipsec20591."${PDN}" TXT +short @8.8.8.8 | sed "s/\"//g" | tr \; '\n' | sed '$d' ); do
						[[ $(echo "${ph}" | cut -d : -f2) == "${2}" ]] && echo "${ph}" | cut -d : -f1
					done
				;;
				"-MR")
					for ph in $(dig ipsec20591."${PDN}" TXT +short @8.8.8.8 | sed "s/\"//g" | tr \; '\n' | sed '$d' ); do
						[[ $(echo "${ph}" | cut -d : -f1) == "${2}" ]] && echo "${ph}" | cut -d : -f2
					done
				;;
                "-T")
                    r=$(tempfile)
                    echo "openbsd "$(dig openbsd."${LDN}" TXT +short| sed "s|;| |g") > "${r}"
                    echo "raspi "$(dig raspi."${LDN}" TXT +short| sed "s|;| |g") >> "${r}"
                    echo "mikrotik "$(dig mikrotik."${LDN}" TXT +short| sed "s|;| |g") >> "${r}"
                    echo "edgeos "$(dig edgeos."${LDN}" TXT +short| sed "s|;| |g") >> "${r}"
                    sed -i "s| \"$|\"|g" "${r}"
                    grep "${2}" "${r}" | cut -d " " -f1
                ;;
			esac
		;;
		*)
			exit 1
		;;
	esac
}


function strip_ansi() {
    declare tmp esc tpa re
    tmp="${1}"
    esc=$(printf "\x1b")
    tpa=$(printf "\x28")
    re="(.*)${esc}[\[${tpa}][0-9]*;*[mKB](.*)"
    while [[ "${tmp}" =~ $re ]]; do
        tmp="${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
    done
    printf "%s" "${tmp}"
}

function mkrtfilter () {
	local tmpdir=$(mktemp -d)
    cp "src/mikrotik/routing_filters.rsc" "${tmpdir}"
	randomop=$(dig TXT openbsd.telecom.lobby +short | sed "s|\"||g" | tr ";" "\n" | awk NF | shuf -n 1)
	ospfin=""
	for host in $(ssh "${randomop}.telecom.lobby" cat /etc/pf.conf.table.{clientes,ipsec} | grep -v \# | awk NF | uniq); do
		ospfin+=$(printf '%s \n' 'add action=accept chain=ospf-in comment="insert HOST '"${host}"'" prefix='"${host}"' prefix-length=32')
	done
	sed -i "s|/OSPFIN/|${osfpin}|" "${tmpdir}/routing_filters.rsc"
	ospfout=""
	for host in $(ssh "${randomop}.telecom.lobby" cat /etc/pf.conf.table.{clientes,ipsec} | grep -v \# | awk NF | uniq); do
		ospfout+=$(printf '%s \n' 'add action=accept chain=ospf-out comment="insert HOST '"${host}"'" prefix='"${host}"' prefix-length=32')
	done
	sed -i "s|/OSPFOUT/|${ospfout}|" "${tmpdir}/routing_filters.rsc"
}

function custom {
	[[ -d "${1}" ]] && (
		for file in $(find $1 -type f -maxdepth $2); do
			(: "${hostname?}") 2>/dev/null && sed -i "s/\/HOSTNAME\//$hostname/g" $file
			(: "${landomainname?}") 2>/dev/null && sed -i "s/\/LANDOMAINNAME\//$landomainname/g" $file
			(: "${routerid?}") 2>/dev/null && sed -i "s/\/ROUTERID\//$routerid/g" $file
			(: "${publichost?}") 2>/dev/null && sed -i "s/\/PUBLICHOST\//$publichost/g" $file
			(: "${domainname?}") 2>/dev/null && sed -i "s/\/DOMAINNAME\//$domainname/g" $file
			(: "${srcid?}") 2>/dev/null && sed -i "s/\/SRCID\//$srcid/g" $file
			(: "${publichostname?}") 2>/dev/null && sed -i "s/\/PUBLICHOSTNAME\//$publichostname/g" $file
			(: "${publicip?}") 2>/dev/null && sed -i "s/\/PUBLICIP\//$publicip/g" $file
			(: "${dyndns?}") 2>/dev/null && sed -i "s/\/DYNDNS\//$dyndns/g" $file
			(: "${publicnetmask?}") 2>/dev/null && sed -i "s/\/PUBLICNETMASK\//$publicnetmask/g" $file
			(: "${publicbcast?}") 2>/dev/null && sed -i "s/\/PUBLICBCAST\//$publicbcast/g" $file
			(: "${ipv6egress?}") 2>/dev/null && sed -i "s/\/PUBV6\//${ipv6egress}/g" $file
			(: "${ipv6prefix?}") 2>/dev/null && sed -i "s/\/PREFIX\//${ipv6prefix}/g" $file
			(: "${defaultv4router?}") 2>/dev/null && sed -i "s/\/ROUTEV4\//${defaultv4router}/g" $file
			(: "${ipv6defrouter?}") 2>/dev/null && sed -i "s/\/ROUTEV6\//${ipv6defrouter}/g" $file
			(: "${longdate?}") 2>/dev/null && sed -i "s/\/LONGDATE\//${longdate}/g" $file
		done
	) || (
		(: "${hostname?}") 2>/dev/null && sed -i "s/\/HOSTNAME\//$hostname/g" $1
		(: "${landomainname?}") 2>/dev/null && sed -i "s/\/LANDOMAINNAME\//$landomainname/g" $1
		(: "${routerid?}") 2>/dev/null && sed -i "s/\/ROUTERID\//$routerid/g" $1
		(: "${publichost?}") 2>/dev/null && sed -i "s/\/PUBLICHOST\//$publichost/g" $1
		(: "${domainname?}") 2>/dev/null && sed -i "s/\/DOMAINNAME\//$domainname/g" $1
		(: "${srcid?}") 2>/dev/null && sed -i "s/\/SRCID\//$srcid/g" $1
		(: "${publichostname?}") 2>/dev/null && sed -i "s/\/PUBLICHOSTNAME\//$publichostname/g" $1
		(: "${publicip?}") 2>/dev/null && sed -i "s/\/PUBLICIP\//$publicip/g" $1
		(: "${dyndns?}") 2>/dev/null && sed -i "s/\/DYNDNS\//$dyndns/g" $1
		(: "${publicnetmask?}") 2>/dev/null && sed -i "s/\/PUBLICNETMASK\//$publicnetmask/g" $1
		(: "${publicbcast?}") 2>/dev/null && sed -i "s/\/PUBLICBCAST\//$publicbcast/g" $1
		(: "${ipv6egress?}") 2>/dev/null && sed -i "s/\/PUBV6\//${ipv6egress}/g" $1
		(: "${ipv6prefix?}") 2>/dev/null && sed -i "s/\/PREFIX\//${ipv6prefix}/g" $1
		(: "${defaultv4router?}") 2>/dev/null && sed -i "s/\/ROUTEV4\//${defaultv4router}/g" $1
		(: "${ipv6defrouter?}") 2>/dev/null && sed -i "s/\/ROUTEV6\//${ipv6defrouter}/g" $1
		(: "${longdate?}") 2>/dev/null && sed -i "s/\/LONGDATE\//${longdate}/g" $1
	)
}

function eui64gen () {
    local HWADDR="$1" IFACE="$2"
    local -a OCTETS
        local IPV6ADDR

        if [[ -z "$IFACE" ]]; then
            IFACE=$(ip route | grep ^default | sed 's/^.* dev //')
        fi

    OCTETS=( ${HWADDR//:/\ } )
    OCTETS[0]=$(printf %02x $((16\#${OCTETS[0]}+0x02)))
    IPV6ADDR="fe80::${OCTETS[0]}${OCTETS[1]}:${OCTETS[2]}ff:fe${OCTETS[3]}:${OCTETS[4]}${OCTETS[5]}%$IFACE"
    echo "$IPV6ADDR"
}
