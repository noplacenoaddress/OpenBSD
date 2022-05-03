<<<<<<< Updated upstream
=======
<<<<<<< HEAD
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ ip ospf authentication md5
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ ip ospf authentication md5 key-id 1 md5-key /OSPFMD5/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ ip ospf dead-interval 40
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ ip ospf hello-interval 10
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ ip ospf priority 1
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ ip ospf retransmit-interval 5
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set interfaces tunnel /TUN/ ip ospf transmit-delay 1
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set protocols ospf area 0.0.0.0 network /GRENETWORK/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set protocols ospf passive-interface-exclude /TUN/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper commit
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper save
=======
>>>>>>> Stashed changes
#!/bin/vbash

set interfaces tunnel /TUN/ ip ospf authentication md5
set interfaces tunnel /TUN/ ip ospf authentication md5 key-id 1 md5-key /OSPFMD5/
set interfaces tunnel /TUN/ ip ospf cost /METRIC/
set interfaces tunnel /TUN/ dead-interval 40
set interfaces tunnel /TUN/ hello-interval 10
set interfaces tunnel /TUN/ network point-to-point
set interfaces tunnel /TUN/ priority 1 
set interfaces tunnel /TUN/ retransmit-interval 5
set interfaces tunnel /TUN/ transmit-delay 1

<<<<<<< Updated upstream
=======
>>>>>>> master
>>>>>>> Stashed changes

