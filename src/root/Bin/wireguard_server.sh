#!/bin/ksh

psk=
while [ -z $psk ]
do
    echo 'Type client pubkey '
    read psk
done
net=
while [ -z $net ]
do
    echo 'Type /30 subnet '
    read net
done
ip=
while [ -z $ip ]
do
    echo 'Type wg tunnel ip '
    read ip
done

PUBKEY="${psk}"
PRIVKEY=$(openssl rand -base64 32)
ifconfig wg > /dev/null 2>&1
[[ $? -eq 1 ]] && (
    let i=0
)
[[ $? -eq 0 ]] && (
    let i=0
    for x in $(ifconfig wg | grep wg*[0-9] | cut -d : -f1 | sed "s|wg||g"); do
        [[ $x -gt $i ]] && i=$x
    done
    ((i+=1))

)
cat <<EOF > /etc/hostname.wg$i
wgkey $PRIVKEY
wgpeer $PUBKEY wgaip ${net}
inet ${ip}
wgport 1300$i
up
EOF

# start interface so we can get the public key
# we should have an error here, this is normal
sh /etc/netstart wg$i

PUBKEY=$(ifconfig wg0 | grep 'wgpubkey' | cut -d ' ' -f 2)
echo "You need $PUBKEY to setup the local peer"
