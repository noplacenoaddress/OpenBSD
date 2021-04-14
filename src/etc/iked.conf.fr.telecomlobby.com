ikev2 "fr.telecomlobby.com" active transport \
	proto gre \
	from /PUBLICIP/ to 45.32.144.15 \
        local /PUBLICHOST/  peer fr.telecomlobby.com \
	ikesa auth hmac-sha2-256 enc aes-256 group ecp384  \
        childsa auth hmac-sha2-256 enc aes-256 \
	srcid "/HOSTNAME/@ca.telecomlobby.com" \
        ikelifetime 86400 lifetime 3600 
