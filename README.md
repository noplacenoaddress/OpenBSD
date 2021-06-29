# OpenBSD on demand mesh host

![Puffy rules](https://www.openbsd.org/art/puffy/ppuf800X725.gif)

The final goal is to add a full configured, secure by default, encrypted mesh node to an existing network. 

It will replicate all the services on the network, and it can be deleted without loosing any data.

Especially focused above security in every ISO/OSI pile level. 

Applications are multiples, from bypass the European [ECHELON](https://en.wikipedia.org/wiki/ECHELON), an enormous sniffer from some ISP, or the great firewall in China, to create very secure not logged chat, to dynamic traditional services that will move from an host to another in a total transparent mode to the final user.

I'm an addicted of privacy and security and I'm very tired about the modern slavery network transmitted by weapons from the European elite. 

*Vatican, a big part of Aristocracy and a lot of leafs, and some corrupted secret services are totally guilty about the recent destroy of democracy. They are owners of an exploitation camp transmitted by electromagnetic weapons and elaborated by artificial intelligence from the Collserola tower in Barcelona above all the Mediterranean area. Electronic slavery, the modern slavery that United Nation is investigating is my goal.*

#### VPS election

First of all you've got to rent a VPS in one service provider, there are a lot on Internet a great resource to find the correct one is this website:

- [Low End Box - Cheap VPS, Dedicated Servers and Hosting Deals](https://lowendbox.com/)

Some that I use or I've used:

- [SSD VPS Servers, Cloud Servers and Cloud Hosting by Vultr - Vultr.com](https://www.vultr.com/)
- [AlphaVPS - Cheap and Reliable Hosting and Servers](https://alphavps.com/)
- [VPS Hosting in Europe and USA. Join VPS2DAY now!](https://www.vps2day.com/)
- [Liveinhost Web Services &#8211; The Best Web Hosting | Fast Professional Website Hosting Services](https://www.liveinhost.com/)
- [Scaleway Dedibox | The Reference for Dedicated Servers  | Scaleway](https://www.scaleway.com/en/dedibox/)

Try to understand that we've got to build a network of VPS interconnected site to site between everyone with IPsec and every host is plug and play, I mean that we can add or remove VPS just running the software in this repository. First of all it is important to understand that we can use this design in two different application, one will use registered domains the other will use free dns services. Goal for everyone is security trough simplicity, open source design and the correct use and implementation of robust compliance protocols and daemons. The system operative is [OpenBSD](https://www.openbsd.org/) but later we will use also [Alpine Linux](https://alpinelinux.org/). At that point the goal will be interoperability and the search of near perfect TCP/IP throughput. Another goal will be the use of ARM64 mobile devices also based up Alpine, my favorite one is:

-  [PinePhone](https://pine64.com/product-category/pinephone/?v=0446c16e2e66)

Another interesting end device based upon open hardware that use [LoRa](https://en.wikipedia.org/wiki/LoRa) and GSM is:

- [ESPboy](https://www.espboy.com/)

#### VPS without OpenBSD as system available

Many times we've got to resolve problems like the one where OpenBSD isn't listed as a default system operative in our remote KVM administration web console. This isn't our death.

First of all install a classic Linux, like Debian for example. Next ssh to the new machine with the credentials provided. Next download the latest stable `miniroot` image into the root and write it to the start of our virtual disk, in linux normally  it will be `vda`.

```sh
# wget https://cdn.openbsd.org/pub/OpenBSD/6.9/amd64/miniroot69.img
# dd if=miniroot69.img of=/dev/vda bs=4M
```

 After the successful write to the virtual disk we've got to reboot the machine but we will do it in a particular way using the `proc` filesystem:

```shell
# echo s > /proc/sysrq-trigger
# echo b > /proc/sysrq-trigger 
```

#### Semi automatic system installation

Open the `KVM` web console and the installation process of OpenBSD will start. Interrupt it choosing for the (S)hell option and:

```shell
# dhclient vio0
# cd /tmp && ftp -o install.conf https://bit.ly/3mEYdAo
# install -af /tmp/install.conf
# reboot
```

The default `root` password in our `install.conf` file is `123456789`. But it is encrypted as `$2b$10$4tPKeRmxVyffVkrQMve70.CiPmE28khH9UXiuSYpzAKbZrOfQq0Pm`.

The default `uid 1000` user is `taglio`, my nickname and unix user. You can update `installation/install-vps` file with your. I also specify my `ed25519` ssh key that I've got generated with `ssh-keygen -t ed25519 -C "taglio@telecom.lobby"`as you can appreciate in the configuration file:

`Public ssh key for user = ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKG4yMhKX37SXV8LGDuVe4r1PBSS5HOWb6jFpNiG3cvW taglio@telecom.lobby`

*Please update this file with your specifications forking my repository*.

After the reboot login in the new node and change the password and upgrade the system with `syspatch`.

#### [![OpenBSD MESH IPSec guerrila host](https://img.youtube.com/vi/6-M4IxeSctI/0.jpg)](https://www.youtube.com/watch?v=6-M4IxeSctI "OpenBSD MESH IPSec guerrila host")

#### First steps

First of all I want to underline that we use some values in the `DNS` master zone of the domain where we want to attach our new `VPS` host. *It's not exactly all automatic*.

``` shell
root@ganesha:/var/nsd/zones/master# cat telecomlobby.com.zone | grep ipsec && cat telecomlobby.com.zone | grep gre
ipsec20591		IN TXT "uk:ganesha;us:saraswati;jp:shiva;es:indra;fr:uma;bg:neo;"
gre7058			IN TXT "216"
gre18994		IN TXT "3"
root@ganesha:/var/nsd/zones/master#
```

We use the [TXT record](https://en.wikipedia.org/wiki/TXT_record) to add some more information to the process of automatically add the new host to our MESH network. Hostname are:

```shell
root@ganesha:/var/nsd/zones/master# echo ipsec${RANDOM} && echo gre${RANDOM} && echo gre${RANDOM}
ipsec6150
gre9262
gre1331
root@ganesha:/var/nsd/zones/master# 
```

```$RANDOM``` is a special variable in `ksh` used to generate random numbers between 0 and 32767.

The string specified by `TXT` value of `ipsec` is `;` separated values and contain [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) [country codes](https://en.wikipedia.org/wiki/Country_code) followed by `:` and the name of the host machine.

The string specified by `TXT` values of the two `gre` are integer, the first between  0 and 255 indicating last /30 network allocated by a `gre` point to point and the second is a counter indicating the number of MESH guerrilla OpenBSD hosts.

Remember to update those `TXT` to archive the connection process.

It's important also to configure DNS resolution and also [RDNS](https://en.wikipedia.org/wiki/Reverse_DNS_lookup) of the assigned IPv4 address in our master zone. Depending on the provider adding the reverse dns resolution host it could be writing to the support office or simply use a web mask.

[![OpenBSD MESH IPSec guerrila host](https://asciinema.org/a/417997.png)](https://asciinema.org/a/417997)

Next we've got to update the master zone of the principle public domain, in my case `telecomlobby.com`.

The first value to update is the IPv4 of the new machine:

```shell
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ dig de.telecomlobby.com A +short
45.63.116.141
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ ssh ganesha.telecom.lobby
Host key fingerprint is SHA256:mZiIJWncSs+jJUjAho8NNQeO1wSHKVpFORP5wZdDaNo
+--[ED25519 256]--+
|+.=BB= o..       |
|=*+O= = +        |
|+OO +B o .       |
|+=oB..Eo o       |
|. + * o S        |
|   + .           |
|  .              |
|                 |
|                 |
+----[SHA256]-----+
OpenBSD 6.9 (GENERIC) #2: Sat May 22 12:49:54 MDT 2021
    root@syspatch-69-amd64.openbsd.org:/usr/src/sys/arch/amd64/compile/GENERIC
real mem = 1056813056 (1007MB)
avail mem = 1009553408 (962MB)
10:49AM  up 2 days, 23:46, 2 users, load averages: 0.01, 0.02, 0.00
ID              Pri State        DeadTime Address         Iface     Uptime
192.168.13.59   1   FULL/P2P     00:00:34 10.10.10.201    gre4      02:55:38
192.168.13.81   1   FULL/P2P     00:00:30 10.10.10.217    gre3      06:51:01
192.168.13.1    1   FULL/P2P     00:00:36 10.10.10.225    gre2      06:45:49
192.168.13.34   1   FULL/P2P     00:00:33 10.10.10.230    gre1      06:51:03
192.168.13.33   1   FULL/P2P     00:00:36 10.10.10.250    gre0      1d06h55m
Go 'way!  You're bothering me!
 
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ doas su
doas (taglio@ganesha.telecom.lobby) password: 
root@ganesha:/home/taglio# cd /var/nsd/zones/master
root@ganesha:/var/nsd/zones/master# cat telecomlobby.com.zone | grep vpnc 
vpnc			IN A 45.32.144.15
vpnc			IN A 78.141.201.0
vpnc			IN A 155.138.247.27
vpnc			IN A 139.180.206.19
vpncN			IN A 94.72.143.163
vpnc			IN TXT "RT-01.cat.telecomlobby.com"
root@ganesha:/var/nsd/zones/master# 

```

As you can see theres some values about the `vpnc` and `vpncN` host:

- `vpnc IN A` in the list of public IPv4 that are connected through IPsec in our MESH network.
- `vpncN IN A` in the new host to add to.

Upgrade the configuration to reflect to new one and test it:

``` shell
riccardo@trimurti:~$ dig @8.8.8.8 vpnc.telecomlobby.com A +short
45.32.144.15
78.141.201.0
155.138.247.27
139.180.206.19
94.72.143.163
riccardo@trimurti:~$ dig @8.8.8.8 vpncN.telecomlobby.com A +short
45.63.116.141
riccardo@trimurti:~$ 
```

In my configuration I've got also a dynamic IPv4 [EdgeOS](https://dl.ubnt.com/guides/edgemax/EdgeOS_UG.pdf) endpoint and another with fixed IPv4 [RouterOS](https://es.wikipedia.org/wiki/MikroTik) one. In EdgeOS I've got to update the black hole routing table excluding the new ip:

```shell
taglio@indra# set protocols static interface-route 45.63.116.141/32 next-hop-interface pppoe0
[edit]
taglio@indra# commit
[edit]
taglio@indra# save
Saving configuration to '/config/config.boot'...
Done
[edit]
taglio@indra# exit
```

In the RouterOS one I've got to update the address list relative to the host presents in my IPSec network:

```shell
[admin@uma.telecom.lobby] /ip firewall address-list> add list=servers comment=durpa address=45.63.116.141/32
[admin@uma.telecom.lobby] /ip firewall address-list> 
```

#### Update the IPSec CA server 

Now start to configure the `CA server` about the `IPsec` public and private key.

In my network layout I've got a [Mikrotik](https://mikrotik.com/) `VPS` that administrate the `IPsec` certificate repositories.

[![Mikrotik CA certificate](https://img.youtube.com/vi/A7O_Pe91a6Y/0.jpg)](https://youtu.be/A7O_Pe91a6Y "Mikrotik CA certificate")

You can use also the RouterOS console:

```shell
[admin@uma.telecom.lobby] > /certificate add name=au.telecomlobby.com country=AU s
tate="New South Wales" locality=Sidney common-name=au.telecomlobby.com subject-alt
-name=email:vishnu@ca.telecomlobby.com
[admin@uma.telecom.lobby] >
```

Download the [p12](https://en.wikipedia.org/wiki/PKCS_12) combined certificate and private key and upload into the new host `/tmp` directory.

``` shell
sftp> get cert_export_de.telecomlobby.com.p12
Fetching /cert_export_de.telecomlobby.com.p12 to cert_export_de.telecomlobby.com.p12
/cert_export_de.telecomlobby.c 100% 3880    74.6KB/s   00:00    
sftp> ^D
riccardo@trimurti:~/Work/redama$ mv cert_export_de.telecomlobby.com.p12 de.telecomlobby.com.p12
riccardo@trimurti:~/Work/redama/durpa$ scp de.telecomlobby.com.p12 taglio@de.telecomlobby.com:/tmp
de.telecomlobby.com.p12        100% 3880   106.4KB/s   00:00    
riccardo@trimurti:~/Work/redama/durpa$ 
```

The p12 file have to be protected by the password `123456789`.

Next use the script `ipsec_newpubkey` to add the new public IPSec key to the `src/etc/iked/pubkeys/ufqdn` directory update the repository and use the console script in the right way:

```shell
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ ./ipsec_newpubkey /home/riccardo/Work/redama/varuna/bg.telecomlobby.com.p12 
neo@ca.telecomlobby.com created please update repository and all the others Openbsd hosts
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ sh git_openbsd.sh 
git add, commit, sign and push
check branch
[taglio-15062021 48dc7f5]  Please enter the commit message for your changes. Lines starting  with '' will be ignored, and an empty message aborts the commit.
 1 file changed, 9 insertions(+)
 create mode 100644 src/etc/iked/pubkeys/ufqdn/neo@ca.telecomlobby.com
Enumerating objects: 14, done.
Counting objects: 100% (14/14), done.
Delta compression using up to 8 threads
Compressing objects: 100% (7/7), done.
Writing objects: 100% (8/8), 1.73 KiB | 886.00 KiB/s, done.
Total 8 (delta 4), reused 3 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (4/4), completed with 4 local objects.
To github.com:redeltaglio/OpenBSD.git
   c773e1e..48dc7f5  taglio-15062021 -> taglio-15062021
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ ./console -I telecom.lobby -G
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ ./console -I telecom.lobby -N

```

#### Login and start the connection process

Install the git package:

```shell
neo# pkg_add git
neo$ mkdir -p Sources/Git && cd Sources/Git
neo$ git clone https://github.com/noplacenoaddress/OpenBSD.git
```

Next let's start to configure the system with our script `setup_node`, you've got to go ahead to every point pressing `1` or to type different variables:

- the type of IPv6 address:
  - `static`: 
    - [IPv6 address](https://en.wikipedia.org/wiki/IPv6) without prefixlen.
    - The [prefixlen](https://www.ciscopress.com/articles/article.asp?p=2803866&seqNum=2).
    - The [IPv6 default route](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/iproute_pi/configuration/xe-16-10/iri-xe-16-10-book/ip6-route-static-xe.pdf).
  - `dynamic`, using [slaacd (8)](https://www.openbsd.org/papers/florian_slaacd_bsdcan2018.pdf)
- `hostname`, the name of the machine.
- `landomainname`, the interior domain name that in my case is `telecom.lobby`
- `routerid`, the OSPFD router id and the IP of the `vether0` interface.

```shell
root@neo:/home/taglio/Sources/Git/OpenBSD# sh setup_node                                                                                                                                                                                          changing installurl
Go ahead type 1 
```

After some points the program give us the root ssh `ed25519` key of the new host. That is [EdDSA](https://en.wikipedia.org/wiki/EdDSA) in [public key cryptography](https://en.wikipedia.org/wiki/Public-key_cryptography).  Update the repository:

``` shell
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ sed -i '/durga.telecom.lobby/d' src/etc/ssh/remote_install/authorized_keys 
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHfCxPKwUqEG9JaEaK6uqFDfDMFYFTblLEWPekGh8CAn root@durga.telecom.lobby" >> src/etc/ssh/remote_install/authorized_keys 
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$
```

To do this operation you can use also the `console` script in the forked repository root:

```shell
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ ./console -I telecom.lobby -RS
Type the LAN hostname 
durga.telecom.lobby
Type the public hostname 
de.telecomlobby.com
Type the ED25519 hash 
AAAAC3NzaC1lZDI1NTE5AAAAIH6Kju+51Vud+0cHKgpdFNSRIpXM/PcLQAO86xKgc+Op
remote_install/authorized_keys and ssh_known_hosts UPDATED
		
 please use git_openbsd.sh to update the public GIT
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$
```

Use the script `git_openbsd.sh` using values depending in your forked repository to update the git.

Next update every host using `git pull` using the `console` script and launch the `newhost` option using the same script:

 ``` shell
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ ./console -I telecom.lobby -G
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ ./console -I telecom.lobby -N
 ```

The `console` script depend on a `TXT` record in the master `nsd` for the LAN domain name:

```shell
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ host -t txt openbsd.telecom.lobby
openbsd.telecom.lobby descriptive text "ganesha;saraswati;shiva;varuna;"
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ 
```

Those are the host names of every OpenBSD guy connected to our network, remember to update it!

[![OpenBSD MESH IPSec guerrila host](https://asciinema.org/a/418749.png)](https://asciinema.org/a/418749)

You've got to update also the CA server inside your network. As the other use the new `ed25519` public key:

```shell
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD-private-CA$ mkdir src/etc/ssh/ca/host/durga.telecom.lobby
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD-private-CA$ echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHfCxPKwUqEG9JaEaK6uqFDfDMFYFTblLEWPekGh8CAn root@durga.telecom.lobby" > src/etc/ssh/ca/host/durpa.telecom.lobby/ssh_host_ed25519_key.pub
```

Update the repository using the script `git_openbsd-private-ca.sh` and next create the new `ssh_host_ed25519_key-cert.pub` with:

```shell
root@cyberanarkhia:/home/taglio/Sources/Git/OpenBSD-private-CA# ./setup_ca                                                                                                                                                                                                       
./setup_ca have to be used with the following options 			
 			
install  -> create SSH and SSL private CA 			
verify   -> printout and verify certificates 			
reset    -> reset filesystem hierarchy and delete certificates and keys 			
transfer -> tar files on /home/taglio 			
newhost -> add a new MESH host 			

root@cyberanarkhia:/home/taglio/Sources/Git/OpenBSD-private-CA# 

```

Use `newhost` and `transfer` options.

[![OpenBSD MESH IPSec guerrila host](https://asciinema.org/a/420482.png)](https://asciinema.org/a/420482)

#### Automatic install

```shell
taglio@varuna:/home/taglio$ cat /tmp/config.ini                                                                                                                                                                                                       static#1
ipv6ctrl#static
ipv6egress#2a01:8740:1:ff48::64a8
ipv6prefix#48
ipv6defrouter#2a01:8740:1:ff00::1
installurl#1
shell#1
users#1
hostname#varuna
landomainname#telecom.lobby
routerid#192.168.13.59
basic#1
unbound#1
ssh#1
ipsec#1
gre#1
pf#1
ospf#1
remote#1
taglio@varuna:/home/taglio$ 

```

This is the configuration file obtained by the semi automatic installation process. You can adapt to your configuration but be careful with the `static` or `dynamic` IPv6. To archive that you can use also the `configure` script in the root of the repository, simply answer to the questions. 

[![OpenBSD MESH IPSec guerrila host](https://asciinema.org/a/421061.png)](https://asciinema.org/a/421061)

#### You successfully installed and connected a new OpenBSD MESH guerrilla host

*Ok baby let's rock&roll. We've configured a new IPSec MESH host in a semi automatic way, a lot of work done in a few clicks with our preferred system operative, the secure fish! OpenBSD!*

The first step after is to add the new [SSHFP](https://en.wikipedia.org/wiki/SSHFP_record) record to our internal [nsd](https://en.wikipedia.org/wiki/NSD) server. Scan them:

```shell
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ ssh-keyscan -D -t ed25519 varuna.telecom.lobby
; varuna.telecom.lobby:22 SSH-2.0-OpenSSH_8.6
varuna.telecom.lobby IN SSHFP 4 1 6e77aacf6c65bac6ff6dcb8e21ce9beb7cb9d832
varuna.telecom.lobby IN SSHFP 4 2 9baacb4c882270c8f37f2fbc847f1094b2b78a34da4650ec24a3b69ad6033dc3
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ 
```

And update the zone in the server and the `openbsd` record:

```shell
root@cyberanarkhia:/var/nsd/zones/master# rcctl restart nsd                                                                                                                                                                                                                 
nsd(ok)
nsd(ok)
root@cyberanarkhia:/var/nsd/zones/master# rcctl restart unbound
unbound(ok)
unbound(ok)
root@cyberanarkhia:/var/nsd/zones/master# cat telecom.lobby | grep varuna                                                                                                                                                                                                        
varuna		IN A 192.168.13.59
varuna.telecom.lobby IN SSHFP 4 1 6e77aacf6c65bac6ff6dcb8e21ce9beb7cb9d832
varuna.telecom.lobby IN SSHFP 4 2 9baacb4c882270c8f37f2fbc847f1094b2b78a34da4650ec24a3b69ad6033dc3
openbsd			IN TXT	 "ganesha;saraswati;shiva;varuna;"
root@cyberanarkhia:/var/nsd/zones/master# 
```

Enter in the new system and add a password, use a great password manager in your workstation like [KeePassXC](https://keepassxc.org/):

```shell
taglio@varuna:/etc$ su
Password:
root@varuna:/etc# passwd taglio
Changing password for taglio.
New password:
Retype new password:
root@varuna:/etc# 
```

Then create a new SSL internal [CSR](https://en.wikipedia.org/wiki/Certificate_signing_request) certificate request and download it to the CA server to create a new [x.509](https://en.wikipedia.org/wiki/X.509) [CRT](https://en.wikipedia.org/wiki/X.690#DER_encoding) for the internal services like `httpd(8)` and the surely next installed daemon [dovecot](https://www.dovecot.org/).

```shell
root@varuna:/home/taglio/Sources/Git/OpenBSD# sh setup_node -A sslcareq 
Generating RSA private key, 2048 bit long modulus
...................................................................+++++
.......+++++
e is 65537 (0x10001)
writing RSA key
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) []:BG
State or Province Name (full name) []:Lovech
Locality Name (eg, city) []:Troyan
Organization Name (eg, company) []:Telecom Lobby
Organizational Unit Name (eg, section) []:VPNC
Common Name (eg, fully qualified host name) []:varuna.telecom.lobby
Email Address []:varuna@ca.telecom.lobby

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
Download csr from http://varuna.telecom.lobby/varuna.telecom.lobby.csr to the CA server
root@varuna:/home/taglio/Sources/Git/OpenBSD#
```

*Recent versions of our tool will do it automatically.*

[![OpenBSD MESH IPSec guerrila host](https://asciinema.org/a/421920.png)](https://asciinema.org/a/421920)

In this video you can appreciate also a [tmux](https://en.wikipedia.org/wiki/Tmux) session with all the OpenBSD host connected via `ssh` automatically, one session to the internal CA server that in my case is `cyberanarkhia`, and the last onto the workstation that in my case is `trimurti`, an [Ubuntu](https://en.wikipedia.org/wiki/Ubuntu) host.

***I'm fighting hard.***

#### Others system operatives 

![VyOS](https://www.programmersought.com/images/37/227a77d35c99e18bb4a03c3aeece6045.png)

In my MESH network I've got to others types of system operatives dedicated to my business of selling Internet and IP transport using terrestrial radio waves. A wireless Internet service provider.

The types of are:

- [EdgeOS](https://dl.ubnt.com/guides/edgemax/EdgeOS_UG.pdf) a commercial and customized version of [VyOS](https://en.wikipedia.org/wiki/VyOS) from [Ubiquiti](https://es.wikipedia.org/wiki/Ubiquiti_Networks). 
- [RouterOS](https://mikrotik.com/software) a commercial and customized version of Linux from [Mikrotik](https://en.wikipedia.org/wiki/MikroTik).

My software build scripts to automatic configure the new hosts also for those guys.

To add the new OpenBSD host to my Mikrotik steps are very simple. Do this in the new guy:

```shell
root@varuna:/home/taglio/Sources/Git/OpenBSD# sh setup_node -A otheros
Download Mikrotik Routeros script from http://varuna.telecom.lobby/fr.telecomlobby.com/fr.telecomlobby.com.rsc
root@varuna:/home/taglio/Sources/Git/OpenBSD# 
```

 And do that from the workstation:

```shell
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ ./console -I telecom.lobby -M
Type the Mikrotik internal hostname 
uma
Type the new OpenBSD internal hostname 
varuna
--2021-06-23 15:27:46--  http://varuna.telecom.lobby/fr.telecomlobby.com/fr.telecomlobby.com.rsc
Resolving varuna.telecom.lobby (varuna.telecom.lobby)... 192.168.13.59
Connecting to varuna.telecom.lobby (varuna.telecom.lobby)|192.168.13.59|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 1686 (1,6K) [application/octet-stream]
Saving to: ‘/tmp/fr.telecomlobby.com.rsc’

/tmp/fr.telecomlobby.com.rsc                                         100%[====================================================================================================================================================================>]   1,65K  --.-KB/s    in 0,07s   

2021-06-23 15:27:46 (22,5 KB/s) - ‘/tmp/fr.telecomlobby.com.rsc’ saved [1686/1686]

fr.telecomlobby.com.rsc                                                                                                                                                                                                                         100% 1686    63.5KB/s   00:00    

Script file loaded and executed successfully
Host varuna.telecom.lobby configured into Mikrotik uma.telecom.lobby
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ 

```

And here you a video:

[![OpenBSD MESH IPSec guerrila host](https://asciinema.org/a/421957.png)](https://asciinema.org/a/421957)

#### Remote upgrade

![](https://redama.es/Imagenes/varuna_shell.png)

If the VPS provider got the option to install OpenBSD, a custom ISO or hasn't the solution is always the same, use `sysupgrade`.

The upgrade our git repository and launch the `upgrade.sh` script. Remember to wait a couple of days after the [release announce](https://www.openbsd.org/69.html) is published by [Theo de Raddt](https://www.theos.com/deraadt/).

#### Possible applications

Let's start discussing how we can boost our presence in Internet using that guerrilla MESH system that guaranty our privacy and security on the web. My first project is regarding a website replicated over different countries in all the languages over the world. Something very important to obtain maximum results about clients, about web goods sell, about be recognized over it and about whatever we want to obtain searching for visibility.

I've got to cases, one is about the correct information about the modern slavery network transmitted by electromagnetic weapons to the marginal and worker class of many countries, also Europeans. The other is to have got a great site about my professional work, Redama, a wireless ISP but also an Internet website that sold security focused end devices and gateways.   

Next some daemons that we've got to configure to start a new world of applications, remember that my goals are:

- a distributed spider to search for clients for my business and to catalog emails, fax numbers and contacts of United Nations personal that work fighting the modern slavery. I'm a private investigator and I've got to massively denunciate the remote neural control and interference to the brain facility.
- a multi language web site, one for my work the other for my page of public compliant. 
- a massive system of alert by www, smtpd and SIP.

#### NSD and PowerDNS

![](https://raw.githubusercontent.com/redeltaglio/OpenBSD/master/img/OpenBSD_5-9.jpg)

[PowerDNS](https://en.wikipedia.org/wiki/PowerDNS) is a [DNS server](https://en.wikipedia.org/wiki/Name_server) that we are going to use because of it [GeoIP](https://en.wikipedia.org/wiki/Internet_geolocation) [features](https://doc.powerdns.com/authoritative/backends/geoip.html). Using that we will reply to dns request in different ways depending on the geographical position of the source IP. Onto the position in the world map of our client. Why? To load balance  requests and to archive a lot of features more.

Next feature for example can be serving a web page in a different language depending on the language used in the web browser of our client but this is another think.

![Political Map](https://upload.wikimedia.org/wikipedia/commons/5/55/Political_Map_of_the_World.png)

```shell
Type the two .com domains (the principle and the secondary) divided by a comma: 
telecomlobby,9-rg.com

telecomlobby: 
   Name Server: B.NS.BUDDYNS.COM
   Name Server: JP.TELECOMLOBBY.COM
   Name Server: UK.TELECOMLOBBY.COM
   Name Server: US.TELECOMLOBBY.COM

DNSSEC not enable onto telecomlobby!
<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>

9-rg.com: 
   Name Server: B.NS.BUDDYNS.COM
   Name Server: JP.TELECOMLOBBY.COM
   Name Server: UK.TELECOMLOBBY.COM
   Name Server: US.TELECOMLOBBY.COM

DNSSEC not enable onto 9-rg.com!
<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>
You've got servers in:


GB	+513030-0000731	Europe/London

{
  "ip": "78.141.201.0",
  "hostname": "uk.telecomlobby.com",
  "city": "London",
  "region": "England",
  "country": "GB",
  "loc": "51.5085,-0.1257",
  "org": "AS20473 The Constant Company, LLC",
  "postal": "EC1A",
  "timezone": "Europe/London",
}
US/Central

{
  "ip": "155.138.247.27",
  "hostname": "us.telecomlobby.com",
  "city": "Dallas",
  "region": "Texas",
  "country": "US",
  "loc": "32.7831,-96.8067",
  "org": "AS20473 The Constant Company, LLC",
  "postal": "75270",
  "timezone": "America/Chicago",
}
Japan

{
  "ip": "139.180.206.19",
  "hostname": "jp.telecomlobby.com",
  "city": "Kamimaruko",
  "region": "Nagano",
  "country": "JP",
  "loc": "36.3186,138.2733",
  "org": "AS20473 The Constant Company, LLC",
  "postal": "386-0404",
  "timezone": "Asia/Tokyo",
}
BG	+4241+02319	Europe/Sofia

{
  "ip": "94.72.143.163",
  "hostname": "bg.telecomlobby.com",
  "city": "Sofia",
  "region": "Sofia-Capital",
  "country": "BG",
  "loc": "42.6975,23.3241",
  "org": "AS203380 DA International Group Ltd.",
  "postal": "1000",
  "timezone": "Europe/Sofia",
}
DE	+5230+01322	Europe/Berlin	Germany (most areas)

{
  "ip": "45.63.116.141",
  "hostname": "de.telecomlobby.com",
  "city": "Frankfurt am Main",
  "region": "Hesse",
  "country": "DE",
  "loc": "50.1155,8.6842",
  "org": "AS20473 The Constant Company, LLC",
  "postal": "60311",
  "timezone": "Europe/Berlin",
}
AU	-3352+15113	Australia/Sydney	New South Wales (most areas)

{
  "ip": "139.180.165.223",
  "hostname": "au.telecomlobby.com",
  "city": "Sydney",
  "region": "New South Wales",
  "country": "AU",
  "loc": "-33.8678,151.2073",
  "org": "AS20473 The Constant Company, LLC",
  "postal": "1001",
  "timezone": "Australia/Sydney",
}
```



Nice Regards,

Riccardo `<taglio>` Giuntoli.

