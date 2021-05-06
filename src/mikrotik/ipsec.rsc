#Mikrotik POP VPN template site to site OpenBSD

/ip ipsec peer
add address=/PUBLICIP//32 exchange-mode=ike2 local-address=/POPIP/ name=/HOSTNAME/_ikev2_cert passive=yes profile=NSA-RECOMMENDED

/ip ipsec identity
add auth-method=digital-signature certificate=/POP/ match-by=certificate peer=/HOSTNAME/_ikev2_cert policy-template-group=group_ikev2_cert remote-certificate=/PUBLICHOST/ remote-id=user-fqdn:/SRCID/@ca./DOMAINNAME/

/ip ipsec policy

add dst-address=/PUBLICIP//32 peer=/HOSTNAME/_ikev2_cert proposal=NSA protocol=gre src-address=/POPIP//32

