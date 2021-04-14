ikev2 "RT-01.cat.telecomlobby.com" passive transport \
	proto gre \
	from /PUBLICIP/ to /DYNDNS/ \
	local /PUBLICHOST/ peer any \
	ikesa auth hmac-sha2-256 enc aes-256 group ecp256  \
        childsa auth hmac-sha2-256 enc aes-256 group ecp256 \
	srcid "/HOSTNAME/@ca.telecomlobby.com"  \
	ikelifetime 86400 lifetime 3600
