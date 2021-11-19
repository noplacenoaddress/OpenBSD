#!/bin/ksh

file=$(ls -alt /tmp | grep ".tar" | head -n 1)
chrlocalhostname=$(echo "${file}" | sed "s|.tar||")
tmpdir=$(mktemp -d)


cd "${tmpdir}"
tar -xvf ../calli.tar
mv tmp/*/* .
rm -rf tmp/
chrpublichostname=$(cat hostname.enc? | head -n 1 | awk '{print $2}' | sed "s|\"||g")
install -o root -g wheel -m 0640 hostname.enc? /etc
install -o root -g wheel -m 0640 hostname.gre? /etc
install -o root -g wheel -m 0640 iked.conf "/etc/iked.conf.${chrpublichostname}"
sed -i "/^}$/d" /etc/ospfd.conf
cat ospfd.conf >> /etc/ospfd.conf
echo "include \"/etc/iked.conf.${chrpublichostname}\"" >> /etc/iked.conf
sh /etc/netstart
sh /etc/netstart
nohup "rcctl restart iked && rcctl restart ospfd" &
exit
