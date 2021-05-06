#!/bin/vbash

set interface tunnel tun/X/
set interface tunnel tun/X/ address /GREPOPIP/
set interface tunnel tun/X/ description /PUBLICHOST/
set interface tunnel tun/X/ encapsulation gre
set interface tunnel tun/X/ firewall
set interface tunnel tun/X/ firewall local
set interface tunnel tun/X/ firewall local name GRE
set interface tunnel tun/X/ local-ip 0.0.0.0
set interface tunnel tun/X/ mtu 1392
set interface tunnel tun/X/ multicast enable
set interface tunnel tun/X/ remote-ip /PUBLICIP/
set interface tunnel tun/X/ ttl 255


