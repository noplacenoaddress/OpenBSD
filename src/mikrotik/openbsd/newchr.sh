#!/bin/ksh

file=$(ls -alt /tmp | grep ".tar" | head -n 1 | awk '{print $9}')
lhn=$(echo "${file}" | sed "s|.tar||")
tmpdir=$(mktemp -d)


cd "${tmpdir}"
tar -xvf ../"${file}"
mv tmp/*/* .
rm -rf tmp/
phn=$(cat hostname.enc? | head -n 1 | awk '{print $2}' | sed "s|\"||g")
x=$(cat hostname.gre? | grep gre | head -n 1 | awk '{print $2}' | sed "s|gre||")
install -o root -g wheel -m 0640 hostname.enc? /etc
install -o root -g wheel -m 0640 hostname.gre? /etc
install -o root -g wheel -m 0640 iked.conf "/etc/iked.conf.${phn}"
sed -i "/^}$/d" /etc/ospfd.conf
cat ospfd.conf >> /etc/ospfd.conf
echo "include \"/etc/iked.conf.${phn}\"" >> /etc/iked.conf
sh /etc/netstart "gre${x}"
sh /etc/netstart "enc${x}"
iked -n  > /dev/null 2>&1
[[ $? == 0 ]] || (logger "iked configuration error" ; exit 1)
iked -n  > /dev/null 2>&1
[[ $? == 0 ]] || (logger "ospfd configuration error" ; exit 1)
{(rcctl restart iked; rcctl restart ospfd) 1>/dev/null &} ; exit
