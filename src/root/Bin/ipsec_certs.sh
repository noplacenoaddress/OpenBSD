#!/bin/ksh

for f in $(ls -al /home/taglio/Sources/Git/OpenBSD/src/etc/iked/certs/*.crt | awk '{print $9}');  do install -o root -g wheel -m 0444 "${f}" /etc/iked/certs/; done
for f in $(ls -al /home/taglio/Sources/Git/OpenBSD/src/etc/iked/pubkeys/fqdn/*telecomlobby* | awk '{print $9}');  do install -o root -g wheel -m 0444 "${f}" /etc/iked/pubkeys/fqdn/; done
for f in $(ls -al /home/taglio/Sources/Git/OpenBSD/src/etc/iked/pubkeys/ufqdn/*telecomlobby* | awk '{print $9}');  do install -o root -g wheel -m 0444 "${f}" /etc/iked/pubkeys/ufqdn/; done
