/file remove [find type=".crt file"]
/file remove [find type="ssh key"]
/file remove [find type=".p12 file"]
/ip ipsec proposal remove [find where name!=default]
/ip ipsec policy remove [find where group!=default dynamic=no]
/ip ipsec identity remove [find where dynamic=no]
/ip ipsec policy group remove [find where name!=default]
/ip ipsec peer remove [find where dynamic=no]
/ip ipsec profile remove [find where name!=default]
/certificate remove [find]
/file remove [find type="script"]
:foreach I in=[/ip firewall mangle find where new-routing-mark=ipsec] do={/ip firewall mangle remove $I}
:foreach I in=[/ip firewall address-list find where list=ipsec] do={/ip firewall address-list remove $I}
:foreach ITEM in=[/interface gre find] do={:local COMMENT [/interface gre get $ITEM comment]; /ip route remove [find where routing-mark="$COMMENT"]}
/ip route remove [find routing-mark=ipsec]
/ip route rule remove [find routing-mark=ipsec]
/ip route remove [find gateway=~gre]
/ip route remove [find where gateway~"^\\*[0-9a-fA-F]{1,8}\$"]
/routing ospf network remove [find]
/routing ospf interface remove [find]
/interface gre remove [find]
/ip addr remove [find comment=ADM]
/ip addr remove [find comment=DATA]
/ip addr remove [find comment=HAM]
/ip addr remove [find interface=lo1]
/ip addr remove [find interface=~gre]
/ip addr remove [find invalid]
/int vlan remove [find comment=ADM]
/int vlan remove [find comment=DATA]
/int vlan remove [find comment=PPPOE]
/int vlan remove [find comment=HAM]
/int bri remove [find]
/routing filter remove [find]
/interface list member remove [find where list=GRE]
/interface list remove [find where name=GRE]
/ip fire filter remove [find]
/ip fire nat remove [find]
/ip firewall mangle remove [find dst-address-list!="ddns" && connection-mark!="ddns"]
/ip fire address-list remove [find list=ipsec]
/ip fire address-list remove [find list=lan]
/ip fire address-list remove [find list=otherswan]
/ip fire address-list remove [find list=roadwarriors]
/ip fire address-list remove [find list=servers]
