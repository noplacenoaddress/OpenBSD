/ip firewall filter

add action=accept chain=input in-interface=[/interface get [/interface gre find where comment="/HOSTNAME/"] name]; protocol=ospf
add action=accept chain=input dst-port=22 in-interface=[/interface get [/interface gre find where comment="/HOSTNAME/"] name]; protocol=tcp src-address-list=lan


/ip firewall mangle

add action=change-mss chain=postrouting ipsec-policy=out,ipsec new-mss=1300 out-interface=[/interface get [/interface gre find where comment="/HOSTNAME/"] name]; passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=!1300-1300


