#Mikrotik POP GRE template site to site OpenBSD

/interface gre
add comment=/HOSTNAME/ keepalive=5s,2 local-address=/POPIP/ mtu=1392 remote-address=/PUBLICIP/ clamp-tcp-mss=no



/ip address
add address=/GREPOPIP//30 interface=[/interface get [/interface gre find where comment="/HOSTNAME/"] name];
