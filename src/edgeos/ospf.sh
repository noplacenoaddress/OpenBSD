/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ ip ospf authentication md5
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ ip ospf authentication md5 key-id 1 md5-key /OSPFMD5/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ ip ospf cost /METRIC/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ ip ospf dead-interval 40
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ ip ospf hello-interval 10
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ ip ospf network point-to-point
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ ip ospf priority 1
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ ip ospf retransmit-interval 5
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ ip ospf transmit-delay 1
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper commit
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper save

