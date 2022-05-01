#!/bin/ksh

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
while [ -z $pop ]
do
    echo 'Type pop endpoint '
    read pop
done
while [ -z $popport ]
do
    echo 'Type pop port endpoint '
    read poport
done

PRIVKEY=$(openssl rand -base64 32)
cat <<EOF > /etc/hostname.wg$i
wgkey $PRIVKEY
wgpeer wgendpoint $pop $popport wgaip $net
inet $ip
up
EOF

# start interface so we can get the public key
# we should have an error here, this is normal
sh /etc/netstart wg$i

PUBKEY=$(ifconfig wg$i | grep 'wgpubkey' | cut -d ' ' -f 2)
echo "You need $PUBKEY to setup the remote peer"
