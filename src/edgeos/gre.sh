#!/bin/vbash

configure
set interface tunnel /TUN/
set interface tunnel /TUN/ address /GREPOPIP/
set interface tunnel /TUN/ description /PUBLICHOST/
set interface tunnel /TUN/ encapsulation gre
set interface tunnel /TUN/ firewall
set interface tunnel /TUN/ firewall local
set interface tunnel /TUN/ firewall local name GRE
set interface tunnel /TUN/ local-ip 0.0.0.0
set interface tunnel /TUN/ mtu 1392
set interface tunnel /TUN/ multicast enable
set interface tunnel /TUN/ remote-ip /PUBLICIP/
set interface tunnel /TUN/ ttl 255
commit
save

