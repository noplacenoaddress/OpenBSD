/routing filter
add action=accept chain=ospf-in comment="insert HOST 192.168.13.0/24 " prefix=192.168.13.0/24 prefix-length=32
add action=accept chain=ospf-in comment=insert NET 172.16.16.0/22" prefix=172.16.16.0/22 prefix-length=24
add action=accept chain=ospf-in comment=insert NET 10.0.0.0/8" prefix=10.0.0.0/8 prefix-length=8
/OSPFIN/
add action=discard chain=ospf-in comment="discard ALL"
add action=accept chain=ospf-out comment="insert HOST 192.168.13.0/24 " prefix=192.168.13.0/24 prefix-length=32
add action=accept chain=ospf-out comment=insert NET 172.16.16.0/22" prefix=172.16.16.0/22 prefix-length=24
add action=accept chain=ospf-out comment=insert NET 10.0.0.0/8" prefix=10.0.0.0/8 prefix-length=8
/OSPFOUT/
add action=discard chain=ospf-out comment="discard ALL"
