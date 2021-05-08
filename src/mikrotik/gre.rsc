#Mikrotik POP GRE template site to site OpenBSD

/interface gre
add comment=/HOSTNAME/ keepalive=5s,2 local-address=45.32.144.15 mtu=1392 remote-address=/PUBLICIP/

/ip address
add address=/GREPOPIP//30 interface=[/interface get [/interface gre find where comment="/HOSTNAME/"] name];
