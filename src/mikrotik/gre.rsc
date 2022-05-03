#Mikrotik POP GRE template site to site OpenBSD

/interface gre
<<<<<<< Updated upstream
add comment=/HOSTNAME/ keepalive=5s,2 local-address=45.32.144.15 mtu=1392 remote-address=/PUBLICIP/
=======
<<<<<<< HEAD
add comment=/HOSTNAME/ keepalive=5s,2 local-address=/POPIP/ mtu=1392 remote-address=/PUBLICIP/ clamp-tcp-mss=no


=======
add comment=/HOSTNAME/ keepalive=5s,2 local-address=45.32.144.15 mtu=1392 remote-address=/PUBLICIP/
>>>>>>> master
>>>>>>> Stashed changes

/ip address
add address=/GREPOPIP//30 interface=[/interface get [/interface gre find where comment="/HOSTNAME/"] name];
