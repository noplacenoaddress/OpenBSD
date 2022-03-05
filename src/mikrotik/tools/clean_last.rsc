# tool to clean a VPS

:global interfacegre "$[ /interface gre get [find comment~"/HOSTNAME/.*"] name; ]"
:global ippublic "$[ /interface gre get [find name="$interfacegre"] remote-address; ]"
:global publichostname "$[ :resolve $ippublic ]"
:global grenetwork "$[ /ip address get [find interface="$interfacegre"] network; ]"

/interface list member remove [find interface="$interfacegre"]
/ip firewall address-list remove [find address="$ippublic" list=ipsec]
/ip firewall mangle remove [find new-connection-mark="/HOSTNAME/"]
/ip firewall mangle remove [find new-routing-mark="/HOSTNAME/"]
/routing ospf network remove [find network~"$grenetwork.*"]
/routing ospf interface remove [find interface="$interfacegre"]
/ip addr remove [find interface="$interfacegre"]
/interface gre remove [find name="$interfacegre"]
/ip ipsec policy remove [find dst-address~"$ippublic.*"]
/ip ipsec peer remove [find address="$ippublic/32"]
/ip ipsec identity remove [find remote-certificate="$publichostname"]
/certificate remove [find common-name="$publichostname"]
