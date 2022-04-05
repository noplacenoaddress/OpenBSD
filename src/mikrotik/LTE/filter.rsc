/ip firewall filter

add action=accept chain=input icmp-options=8:0-255 protocol=icmp
add action=accept chain=input connection-state=established
add action=accept chain=input connection-state=related
add action=drop chain=output dst-address-list=servers ipsec-policy=out,none log=yes log-prefix="GRE ERROR" out-interface=lte1 protocol=gre src-address=/PUBLICIP/
add action=accept chain=input in-interface-list=GRE protocol=ospf
add action=accept chain=input dst-port=21,22,80,8291 in-interface-list=GRE protocol=tcp src-address-list=lan
add action=accept chain=input dst-port=22,8291 in-interface=l2tp-out1 log=yes log-prefix="Install daemons" protocol=tcp src-address-list=servers
add action=accept chain=input dst-port=22,8291 in-interface=l2tp-out1 log=yes log-prefix="Install daemons" protocol=tcp src-address=172.16.30.1
add action=drop chain=input comment=LAST log=yes log-prefix="debug drop input"
add action=accept chain=forward connection-state=new dst-address=172.16.17.106 dst-port=80,443 in-interface=ether1 protocol=tcp
add action=drop chain=forward connection-state=new dst-address-list=lan in-interface=ether1

/ip firewall mangle

add action=change-mss chain=postrouting connection-state=new new-mss=1300 out-interface-list=GRE passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=!1300-1300

/ip firewall nat
add action=masquerade chain=srcnat out-interface-list=WAN src-address=172.16.19.0/24

add action=masquerade chain=srcnat out-interface-list=WAN src-address=172.16.17.0/24
add action=masquerade chain=srcnat out-interface-list=WAN src-address=172.16.18.0/24
add action=masquerade chain=srcnat out-interface-list=WAN src-address=172.16.16.0/24
add action=masquerade chain=srcnat out-interface-list=WAN src-address-list=otherswan
add action=dst-nat chain=dstnat dst-address=/PUBLICIP/ dst-port=80 in-interface=ether1 protocol=tcp to-addresses=172.16.17.106
