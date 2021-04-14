ikev2 "uk.telecomlobby.com" passive transport \
        proto gre \
        from /PUBLICIP/ to 78.141.201.0 \
        local /PUBLICHOST/ peer uk.telecomlobby.com \
        ikesa  prf hmac-sha2-512  enc aes-256-gcm-12 group brainpool512  \
        childsa  enc chacha20-poly1305 group curve25519 \
        srcid "/HOSTNAME/@ca.telecomlobby.com" \
        ikelifetime 86400 lifetime 3600
