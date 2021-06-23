/ip fire filter remove [/ip fire filter find comment=LAST]

/ip firewall filter

add action=accept chain=input protocol=ospf in-interface=[/interface get [/interface gre find where comment="/HOSTNAME/"] name]; 
add action=accept chain=input dst-port=22 protocol=tcp src-address-list=lan in-interface=[/interface get [/interface gre find where comment="/HOSTNAME/"] name]; 
add action=drop chain=input comment=LAST log-prefix="debug drop input"

/ip firewall mangle

add action=change-mss chain=postrouting ipsec-policy=out,ipsec new-mss=1300 passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=!1300-1300 out-interface=[/interface get [/interface gre find where comment="/HOSTNAME/"] name]; 


