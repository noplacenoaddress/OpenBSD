<<<<<<< Updated upstream
=======
<<<<<<< HEAD
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ address /GREPOPIP//30
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ description /PUBLICHOST/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ encapsulation gre
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ firewall
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ firewall local
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ firewall local name GRE
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ local-ip 2.139.174.201
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ mtu 1392
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ multicast enable
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ remote-ip /PUBLICIP/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ ttl 255
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set firewall group address-group OPENBSD address /PUBLICIP/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set protocols static table /ROUTERIDLAST/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set protocols static table /ROUTERIDLAST/ description /PUBLICHOST/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set protocols static table /ROUTERIDLAST/ interface-route 0.0.0.0/0 next-hop-interface /TUN/
/OTHERSSTATIC/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper commit
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper save
=======
>>>>>>> Stashed changes
#!/bin/vbash

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


<<<<<<< Updated upstream
=======
>>>>>>> master
>>>>>>> Stashed changes
