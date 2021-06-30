/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ address /GREPOPIP//30
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ description /PUBLICHOST/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ encapsulation gre
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ firewall
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ firewall local
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ firewall local name GRE
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ local-ip 0.0.0.0
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ mtu 1392
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ multicast enable
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ remote-ip /PUBLICIP/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ ttl 255
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set firewall group address-group PPPOE address /PUBLICIP/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set protocols static table /ROUTERIDLAST/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set protocols static table /ROUTERIDLAST/ description /PUBLICHOSTNAME/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set protocols static table /ROUTERIDLAST/ interface-route 0.0.0.0/0 next-hop-interface /TUN/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper commit
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper save
