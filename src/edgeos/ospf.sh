configure
set interfaces tunnel /TUN/ ip ospf authentication md5
set interfaces tunnel /TUN/ ip ospf authentication md5 key-id 1 md5-key /OSPFMD5/
set interfaces tunnel /TUN/ ip ospf cost /METRIC/
set interfaces tunnel /TUN/ dead-interval 40
set interfaces tunnel /TUN/ hello-interval 10
set interfaces tunnel /TUN/ network point-to-point
set interfaces tunnel /TUN/ priority 1 
set interfaces tunnel /TUN/ retransmit-interval 5
set interfaces tunnel /TUN/ transmit-delay 1
commit
save
