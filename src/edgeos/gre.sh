configure
set interfaces tunnel /TUN/
set interfaces tunnel /TUN/ address /GREPOPIP//30
set interfaces tunnel /TUN/ description /PUBLICHOST/
set interfaces tunnel /TUN/ encapsulation gre
set interfaces tunnel /TUN/ firewall
set interfaces tunnel /TUN/ firewall local
set interfaces tunnel /TUN/ firewall local name GRE
set interfaces tunnel /TUN/ local-ip 0.0.0.0
set interfaces tunnel /TUN/ mtu 1392
set interfaces tunnel /TUN/ multicast enable
set interfaces tunnel /TUN/ remote-ip /PUBLICIP/
set interfaces tunnel /TUN/ ttl 255
commit
save
