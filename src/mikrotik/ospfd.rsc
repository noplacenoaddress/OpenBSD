/routing ospf interface
<<<<<<< Updated upstream
add authentication=md5 authentication-key=/OSPFMD5/ comment=/POPHOSTNAME/-/PUBLICHOSTNAME/ cost=/METRIC/ interface=[/interface get [/interface gre find where comment="/HOSTNAME/"] name] network-type=point-to-point
=======
<<<<<<< HEAD
add authentication=md5 authentication-key=/OSPFMD5/ comment=/POPHOSTNAME/-/PUBLICHOSTNAME/ interface=[/interface get [/interface gre find where comment="/HOSTNAME/"] name] network-type=point-to-point
=======
add authentication=md5 authentication-key=/OSPFMD5/ comment=/POPHOSTNAME/-/PUBLICHOSTNAME/ cost=/METRIC/ interface=[/interface get [/interface gre find where comment="/HOSTNAME/"] name] network-type=point-to-point
>>>>>>> master
>>>>>>> Stashed changes
/routing ospf network
add area=backbone network=/GRENETWORK//30

