/routing ospf interface
add authentication=md5 authentication-key=/OSPFMD5/ comment=/POPHOST/-/PUBLICHOSTNAME/ cost=/METRIC/ interface=[/interface get [/interface gre find where comment="/HOSTNAME/"] name] network-type=point-to-point
/routing ospf network
add area=backbone network=/GRENETWORK/

