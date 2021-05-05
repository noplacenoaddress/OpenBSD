#Mikrotik POP VPN template site to site OpenBSD

/interface gre
add comment=/HOSTNAME/ keepalive=5s,2 local-address=45.32.144.15 mtu=1392 remote-address=/PUBLICIP/

