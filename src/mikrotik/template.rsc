/ip ipsec profile
add dh-group=ecp384,modp3072 dpd-interval=15s dpd-maximum-failures=1 enc-algorithm=aes-256 hash-algorithm=sha256 name=NSA-RECOMMENDED nat-traversal=no

/ip ipsec peer
add address=/PUBLICIP//32 exchange-mode=ike2 local-address=/POPIP/ name=/HOSTNAME/_ikev2_cert passive=yes profile=NSA-RECOMMENDED

/ip ipsec proposal
add auth-algorithms=sha256 enc-algorithms=aes-256-cbc lifetime=1h name=NSA pfs-group=none

/ip ipsec identity
add auth-method=digital-signature certificate=/POP/ match-by=certificate peer=/HOSTNAME/_ikev2_cert policy-template-group=group_ikev2_cert remote-certificate=/PUBLICHOST/ remote-id=user-fqdn:/HOSTNAME/@ca./DOMAINNAME/

/ip ipsec policy

add dst-address=/PUBLICIP//32 peer=/HOSTNAME/_ikev2_cert proposal=NSA protocol=gre src-address=/POPIP//32

