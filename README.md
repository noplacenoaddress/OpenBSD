

# OpenBSD "Redama" guerrilla services network

![](https://github.com/redeltaglio/OpenBSD/raw/master/img/puffy/puflogv1000X650.gif)

A full configured, secure by default, encrypted services network called "Redama", my business name.

It will replicate all the services on the network, and it can be deleted without loosing any data.

Especially focused above security in every ISO/OSI pile level. 

Applications are multiples, from bypass the European [ECHELON](https://en.wikipedia.org/wiki/ECHELON), an enormous sniffer from some ISP, or the great firewall in China, to create very secure not logged chat, to dynamic traditional services that will move from an host to another in a total transparent mode to the final user.

I'm an addicted of privacy and security and I'm very tired about the modern slavery network transmitted by weapons from the European elite. 

*Vatican, a big part of Aristocracy and a lot of leafs, and some corrupted secret services are totally guilty about the recent destroy of democracy. They are owners of an exploitation camp transmitted by electromagnetic weapons, radio that modulates hided behind FM broadcast official transmissions, and elaborated by artificial intelligence from the Collserola tower in Barcelona above all the Mediterranean area. Electronic slavery, the modern slavery that United Nation is investigating is my goal. With the same technology but with other type of use some nobles administrate Mafia, terrorism, manipulation, mental domination, corruption, fiscal frauds and so on. But in this case modulation is transmitted by many others towers.*

#### VPS election

First of all you've got to rent a VPS in one service provider, there are a lot on Internet a great resource to find the correct one is this website:

- [Low End Box - Cheap VPS, Dedicated Servers and Hosting Deals](https://lowendbox.com/)

Some that I use or I've used:

- [SSD VPS Servers, Cloud Servers and Cloud Hosting by Vultr - Vultr.com](https://www.vultr.com/)
- [AlphaVPS - Cheap and Reliable Hosting and Servers](https://alphavps.com/)
- [VPS Hosting in Europe and USA. Join VPS2DAY now!](https://www.vps2day.com/)
- [Liveinhost Web Services &#8211; The Best Web Hosting | Fast Professional Website Hosting Services](https://www.liveinhost.com/)
- [Scaleway Dedibox | The Reference for Dedicated Servers  | Scaleway](https://www.scaleway.com/en/dedibox/)
- [CreeperHost](https://www.creeperhost.net/)
- [GINERNET, your Hosting and Server provider in Spain](https://ginernet.com/en/)
- [Hostafrica](https://hostafrica.com)

Try to understand that we've got to build a network of VPS interconnected site to site between everyone with IPsec and every host is plug and play, I mean that we can add or remove VPS just running the software in this repository. First of all it is important to understand that we can use this design in two different application, one will use registered domains the other will use free dns services. Goal for everyone is security trough simplicity, open source design and the correct use and implementation of robust compliance protocols and daemons. The system operative is [OpenBSD](https://www.openbsd.org/) but later we will use also [Alpine Linux](https://alpinelinux.org/). At that point the goal will be interoperability and the search of near perfect TCP/IP throughput. Another goal will be the use of ARM64 mobile devices also based up Alpine, my favorite one is:

-  [PinePhone](https://pine64.com/product-category/pinephone/?v=0446c16e2e66)

Another interesting end device based upon open hardware that use [LoRa](https://en.wikipedia.org/wiki/LoRa) and GSM is:

- [ESPboy](https://www.espboy.com/)

#### VPS without OpenBSD as system available

Many times we've got to resolve problems like the one where OpenBSD isn't listed as a default system operative in our remote KVM administration web console. This isn't our death.

First of all install a classic Linux, like Debian for example. Next ssh to the new machine with the credentials provided. Next download the latest stable `miniroot` image into the root and write it to the start of our virtual disk, in linux normally  it will be `vda`. Or if it is not find it with `fdisk -l`.

```sh
# wget https://cdn.openbsd.org/pub/OpenBSD/7.0/amd64/miniroot70.img
# dd if=miniroot70.img of=/dev/vda bs=4M
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

From [release 7.0](https://www.openbsd.org/70.html) command to obtain dynamic IPv4 configuration will be:

```bash
# ifconfig vio0 autoconf
```

If there is no dhcp or slaac server active in the network you can manual configure networking:

```bash
# ifconfig vio0 160.119.248.111/24
# route add 0.0.0.0/0 160.119.248.1
# echo nameserver 8.8.8.8 > /etc/resolv.conf
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

> Remember that is important also take care about the subnet range in the case that the number interfaces multiplied by four give a number inferior that the last ip or we've got to add another subnet as we discuss below in "routine maintenance" section.

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

In my configuration I've got also a dynamic IPv4 [EdgeOS](https://dl.ubnt.com/guides/edgemax/EdgeOS_UG.pdf) endpoint and another with fixed IPv4 [RouterOS](https://es.wikipedia.org/wiki/MikroTik) one. In EdgeOS I've got to  add the `ROUTERID` of the new OpenBSD mesh host to the relative address-group and to the policy access list 10 using the correct rule number.

```shell
root@indra# set firewall group address-group OPENBSD address 216.238.100.26
[edit]
root@indra# 
root@indra# set firewall group address-group ROUTERID address 192.168.13.55
[edit]
root@indra# set policy access-list 10 rule 15 source host 192.168.13.55
[edit]
root@indra# set protocols static interface-route 216.238.100.26/32 next-hop-interface pppoe0 description xolotl
[edit]
root@indra# commit
[edit]
root@indra# save
Saving configuration to '/config/config.boot'...
Done
[edit]
root@indra# exit
```

In the RouterOS one I've got to update the address list relative to the host presents in my IPSec network:

```shell
[admin@uma.telecom.lobby] /ip firewall address-list> add list=ipsec comment=durga address=45.63.116.141/32
[admin@uma.telecom.lobby] /ip firewall address-list> 
```

If in our constellation we've got more than one RouterOS or EdgeOS instance please do the same in every one.

#### Update the IPSec CA server 

Now start to configure the `CA server` about the `IPsec` public and private key.

In my network layout I've got a [Mikrotik](https://mikrotik.com/) `VPS` that administrate the `IPsec` certificate repositories, it is called `uma`. Use [ipinfo](https://ipinfo.io/) to obtain data about the `SSL` variables to fill, we can query the database using IPv4 or IPv6 like I've done in this example:

```bash
taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ curl http:/ipinfo.io/2001:19f0:b400:1655:5400:03ff:fea7:c37b      
{
  "ip": "2001:19f0:b400:1655:5400:03ff:fea7:c37b",
  "city": "El Colorado",
  "region": "Querétaro",
  "country": "MX",
  "loc": "20.5618,-100.2452",
  "org": "AS20473 The Constant Company, LLC",
  "postal": "76246",
  "timezone": "America/Mexico_City",
  "readme": "https://ipinfo.io/missingauth"
}
taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ 
```

[![Mikrotik CA certificate](https://img.youtube.com/vi/A7O_Pe91a6Y/0.jpg)](https://youtu.be/A7O_Pe91a6Y "Mikrotik CA certificate")



You can use also the RouterOS console:

```shell
[admin@uma.telecom.lobby] > /certificate add name=au.telecomlobby.com country=AU s
tate="New South Wales" locality=Sidney common-name=au.telecomlobby.com subject-alt
-name=email:vishnu@ca.telecomlobby.com
[admin@uma.telecom.lobby] >
```

Then sign it with the CA certificate and trust it.

Download the [p12](https://en.wikipedia.org/wiki/PKCS_12) archive from the Mikrotik CA server:

``` shell
sftp> get cert_export_de.telecomlobby.com.p12 de.telecomlobby.com.p12
Fetching /cert_export_de.telecomlobby.com.p12 to de.telecomlobby.com.p12
/cert_export_de.telecomlobby.c 100% 3880    74.6KB/s   00:00    
sftp> ^D
riccardo@trimurti:~/Work/redama/durpa$ 
```

You can use the `tools/pk12extract` script to manipulate the `pk12` archive and obtain different formats.

Next use the script `console` to add the new public IPSec key to the `src/etc/iked/pubkeys/ufqdn` directory update the repository (this time I'll use `mx.telecomlobby.com` because thinks are changed at 11/2021). Script will also upload archive to the new OpenBSD VPS into the `/tmp` directory:

```shell
taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ ./console -I telecom.lobby -K
Type the PATH to the new iked PK12 file 
/home/taglio/Work/redama/ipsec/xolotl/mx.telecomlobby.com.p12
# Host mx.telecomlobby.com found: line 170
/home/taglio/.ssh/known_hosts updated.
Original contents retained as /home/taglio/.ssh/known_hosts.old
The authenticity of host 'mx.telecomlobby.com (216.238.69.44)' can't be established.
ECDSA key fingerprint is SHA256:D9BLMj/rAp0UfZ/PgY/woXUh+v4wJBK0DFkeCXRLUMg.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'mx.telecomlobby.com' (ECDSA) to the list of known hosts.
Warning: the ECDSA host key for 'mx.telecomlobby.com' differs from the key for the IP address '216.238.69.44'
Offending key for IP in /home/taglio/.ssh/known_hosts:166
Are you sure you want to continue connecting (yes/no)? yes
mx.telecomlobby.com.p12                                                                                                                                                                                                                                 100% 3880    16.3KB/s   00:00    
xolotl@ca.telecomlobby.com created please update repository and all the others Openbsd hosts
taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ ./console -I telecom.lobby -G
taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ ./console -I telecom.lobby -N

```

#### Inet6

Ipv6 need special attention in case of dynamic address configuration. Look at our template:

```bash
taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ cat src/etc/hostname.egress | grep inet6 | grep -v \-
inet6 autoconf temporary -soii
taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ 
```

We've got three options to the [inet6](https://en.wikipedia.org/wiki/IPv6) family for the `egress` interface:

- `autoconf`,  [slaacd(8)](https://man.openbsd.org/slaacd) automatically configures IPv6 addresses for interfaces with AUTOCONF6  set.
- `temporary`,  enable temporary address extensions for stateless IPv6 address autoconfiguration [RFC 8981](https://datatracker.ietf.org/doc/html/rfc8981) on the interface. The purpose of these extensions is to prevent tracking of individual devices which connect to the IPv6  internet from different networks using stateless autoconfiguration. 
- `soii` , enable persistent Semantically Opaque Interface Identifier , as per [RFC 7217](https://datatracker.ietf.org/doc/html/rfc7217), for SLAAC addresses on the interface.

As you can understand the last twos are security extensions to guarantee more privacy upon the inet6 configuration, next we will apply even more security using [pf](https://www.openbsd.org/faq/pf/) . We can retry more information using [ifconfig(8)](https://man.openbsd.org/ifconfig.8) and [slaacctl(8)](https://man.openbsd.org/slaacctl.8).

```bash
taglio@ganesha:/home/taglio/Work/telecomlobby.com/bin$ ifconfig egress inet6
vio0: flags=248843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST,AUTOCONF6TEMP,AUTOCONF6> mtu 1500
        lladdr 56:00:02:79:3b:4d
        index 1 priority 0 llprio 3
        groups: egress
        media: Ethernet autoselect
        status: active
        inet6 fe80::5400:2ff:fe79:3b4d%vio0 prefixlen 64 scopeid 0x1
        inet6 2001:19f0:7401:8c01:25f9:5be9:8daa:f2d5 prefixlen 64 autoconf pltime 604554 vltime 2591754
        inet6 2001:19f0:7401:8c01:8b1f:e3eb:c78d:77f4 prefixlen 64 deprecated autoconf temporary pltime 0 vltime 86385
        inet6 2001:19f0:7401:8c01:739b:2a15:122e:6f6b prefixlen 64 autoconf temporary pltime 48768 vltime 156889
taglio@ganesha:/home/taglio/Work/telecomlobby.com/bin$ slaacctl show interface  
vio0:
         index:   1 running: yes temporary: yes
        lladdr: 56:00:02:79:3b:4d
         inet6: fe80::5400:2ff:fe79:3b4d%vio0
        Router Advertisement from fe80::fc00:2ff:fe79:3b4d%vio0
                received: 2021-12-28 10:13:39; 88s ago
                Cur Hop Limit:  64, M: 0, O: 0, Router Lifetime:  1800s
                Default Router Preference: Medium
                Reachable Time:         0ms, Retrans Timer:         0ms
                MTU: 1500 bytes
                prefix: 2001:19f0:7401:8c01::/64
                        On-link: 1, Autonomous address-configuration: 1
                        vltime:    2592000, pltime:     604800
                rdns: 2001:19f0:300:1704::6, lifetime: 3600
        Address proposals
                id:    8, state:      CONFIGURED, temporary: y
                vltime:     156879, pltime:      48758, timeout:      48655s
                updated: 2021-12-28 10:13:39; 88s ago
                2001:19f0:7401:8c01:739b:2a15:122e:6f6b, 2001:19f0:7401:8c01::/64
                id:    6, state:      CONFIGURED, temporary: y
                vltime:      86375, pltime:          0, timeout:      86272s
                updated: 2021-12-28 10:13:39; 88s ago
                2001:19f0:7401:8c01:8b1f:e3eb:c78d:77f4, 2001:19f0:7401:8c01::/64
                id:    5, state:      CONFIGURED, temporary: n
                vltime:    2592000, pltime:     604800, timeout:     604697s
                updated: 2021-12-28 10:13:39; 88s ago
                2001:19f0:7401:8c01:25f9:5be9:8daa:f2d5, 2001:19f0:7401:8c01::/64
        Default router proposals
                id:    4, state:      CONFIGURED
                router: fe80::fc00:2ff:fe79:3b4d%vio0
                router lifetime:       1800
                Preference: Medium
                updated: 2021-12-28 10:13:39; 88s ago, timeout:       1697s
        rDNS proposals
                id:    7, state:            SENT
                router: fe80::fc00:2ff:fe79:3b4d%vio0
                rdns lifetime:       3600
                rdns:
                        2001:19f0:300:1704::6
                updated: 2021-12-28 10:13:39; 88s ago, timeout:       3497s
taglio@ganesha:/home/taglio/Work/telecomlobby.com/bin$ 
```

#### Hurricane Electric 

![](https://www.capacitymedia.com/Image/ServeImage?id=46707&w=780&h=442&cr=true)

In the case of `static` configuration of the `inet6` stack upon our `egress` interface and if our `VPS` provider doesn't bind IPv6 services to the customers it's possible to configure a tunnel [6to4](https://datatracker.ietf.org/doc/html/rfc3056) from [Hurricane Electric](https://en.wikipedia.org/wiki/Hurricane_Electric) and route traffic over it. The tunnel will use the [gif(4)](https://man.openbsd.org/gif.4) pseudo device and our `setup_node` will configure it in a few commands:

```bash
Is IPv6 tunneled through Hurricane Electric? yes/no yes
Type the IPv4 of the Hurricane Electric endpoint 216.66.87.134
Type the IPv6 /128 of the  local gif interface 2001:470:1f22:486::2 
Type the IPv6 /128 of the Hurricane Electric endpoint 2001:470:1f22:486::1 
Type the IPv6 endpoint from the /64 routed from the Hurricane Electric tunnel 2001:470:1f23:486::1 
```

#### Login and start the connection process

Install the git package:

```shell
neo# pkg_add git
neo$ mkdir -p Sources/Git && cd Sources/Git
neo$ git clone https://github.com/redeltaglio/OpenBSD.git
```

Next let's start to configure the system with our script `setup_node`, you've got to go ahead to every point pressing `1` or to type different variables:

- the type of IPv6 address:
  - `static`: 
    - [IPv6 address](https://en.wikipedia.org/wiki/IPv6) without prefixlen.
    - The [prefixlen](https://www.ciscopress.com/articles/article.asp?p=2803866&seqNum=2).
    - The [IPv6 default route](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/iproute_pi/configuration/xe-16-10/iri-xe-16-10-book/ip6-route-static-xe.pdf).
  - `static over gif tunnel`: see above.
  - `dynamic`, using [slaacd (8)](https://www.openbsd.org/papers/florian_slaacd_bsdcan2018.pdf)
- `hostname`, the name of the machine.
- `landomainname`, the interior domain name that in my case is `telecom.lobby`
- `routerid`, the OSPFD router id and the IP of the `vether0` interface.

Start with the configuration and <u>remember to put your route to 0.0.0.0 outside the OpenBSD MESH network!</u>

```shell
root@neo:/home/taglio/Sources/Git/OpenBSD# sh setup_node                                                                                                                                 changing installurl
Go ahead type 1 
```

After some points the program give us the root ssh `ed25519` key of the new host. That is [EdDSA](https://en.wikipedia.org/wiki/EdDSA) in [public key cryptography](https://en.wikipedia.org/wiki/Public-key_cryptography).  Update the repository using the `console` script:

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
taglio@varuna:/home/taglio$ cat /tmp/config.ini                                                                                        static#1
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

##### You successfully installed and connected a new OpenBSD MESH guerrilla host

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

### Others system operatives 

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

From the workstation first of all upload the p12 certificate into the other Mikrotik CHR istances:

```bash
taglio@trimurti:~/Work/redama/ipsec/xolotl$ sftp calli.telecom.lobby
Connected to calli.telecom.lobby.
sftp> put br.telecomlobby.com.p12 
Uploading br.telecomlobby.com.p12 to /br.telecomlobby.com.p12
br.telecomlobby.com.p12                                                                                                                                                                                                                                 100% 3880   267.0KB/s   00:00    
sftp> 
taglio@trimurti:~/Work/redama/ipsec/xolotl$ ssh calli.telecom.lobby
[taglio@calli.telecom.lobby] > /certificate import file-name=br.telecomlobby.com.p12 name=br.telecomlobby.com passphrase=123456789
     certificates-imported: 1
     private-keys-imported: 1
            files-imported: 1
       decryption-failures: 0
  keys-with-no-certificate: 0

[taglio@calli.telecom.lobby] > 
```

Next for every CHR:

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

At least one cheat: if you want to reinstall the OpenBSD VPS simply reboot from `ssh` and the using the web [noVNC](https://novnc.com/info.html) virtual terminal at the boot loader prompt type `boot bsd.rd`.

#### Add a new Mikrotik Cloud Hosted Router 

As you can add a new OpenBSD VPS to the network, it's possible also to add a new Mikrotik VPS. Normally I use RouterOS as my WISP client endpoint IPSEC. Connection is a little bit more stable and fluid than with OpenBSD, remember that I've got an EdgeOS in my physic installation. 

The OpenBSD network is more focused as Content Delivery Network, serving web pages and other services geographically  located in different parts of the world.

I report the routine to buy a new CHR virtual router license. 

Licenses in CHR that are router instances running over cloud VPS services are different from the physics ones. 

![](https://github.com/redeltaglio/OpenBSD/raw/master/img/routeros_licences.jpg)

1. Install RouterOS using the procedure described apropos OpenBSD over a Linux installation.  
2. Do this downloading the [RAW disc image](https://en.wikipedia.org/wiki/IMG_(file_format)) of the RouterOS prepared for [Cloud Hosted Router](https://help.mikrotik.com/docs/pages/viewpage.action?pageId=18350234).
3. Open an account into the [Mikrotik client page](https://mikrotik.com/client).
4. As you can see in the image above System ID is different from physic or X86 installations. Press "Renew License" to get a one month limited free trial. When it will expire you will see a check upon "Limited Upgrades". 
5. But the license in your account page.

Next we've got to prepare the domain name zone with the propers values to indicate to others peers the new entry as we've done with OpenBSD, in this example the CHR istance to add is `ixp.telecomlobby.com` as public host name and `calli.telecom.lobby` as internal host name. As usual we edit those values:

- an A entry for `ixp`, in the cloud service we will add the PTR for the ip. 
- `vpnc` and `vpncN` A values, passing the last host added from `vpncN` to the `vpnc` pool (something used normally to obtain DNS [load balancing](https://en.wikipedia.org/wiki/Load_balancing_(computing)) as with [round robin](https://en.wikipedia.org/wiki/Round-robin_DNS)) .
- `ipsec20591` append to the TXT string `ixp:calli;`.
- `gre7058` add the last /30 configured as usual, in this case `104`.
- `gre18994` the number of the hosts in the `vpnc` pool, in this case `8`.

Next create the `p12` compressed and encrypted certificate as we've done with OpenBSD. Download it locally onto the workstation and use another time the `console` script with `-K` option. Remember to have an IPv4 running stack configured and to change the default `admin` user into your user, in my case `taglio`. Do it adding the new one allowing only your public address, rejoin winbox or ssh and then delete `admin`.

```bash
 [admin@MikroTik] > /user add name=taglio group=full address=94.72.143.163/32 password=
```

Add a password, I generate it with a password administration tool.

```bash
taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ mv /home/taglio/Work/redama/calli/cert_export_ixp.telecomlobby.com.p12 /home/taglio/Work/redama/calli/ixp.telecomlobby.com.p12
taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ ./console -I telecom.lobby -K
Type the PATH to the new iked PK12 file 
/home/taglio/Work/redama/calli/ixp.telecomlobby.com.p12
Host ixp.telecomlobby.com not found in /home/taglio/.ssh/known_hosts
The authenticity of host 'ixp.telecomlobby.com (5.134.119.135)' can't be established.
RSA key fingerprint is SHA256:HtT0d7oUb8r/r43utGn4+9nfSL34tzYHn7xavgVPmW8.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'ixp.telecomlobby.com,5.134.119.135' (RSA) to the list of known hosts.
taglio@ixp.telecomlobby.com's password: 
ixp.telecomlobby.com.p12                                                                                                                                                                                                                                100% 3874    33.0KB/s   00:00    
calli@ca.telecomlobby.com created please update repository and all the others Openbsd hosts
taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ 
```

Next update the Github public repository, and pull all the OpenBSD hosts. Sequence of commands are:

```bash
sh git_openbsd.sh
./console -I telecom.lobby -G
./console -I telecom.lobby -N
```

It's important to have a directory out of the repository with all the p12 compressed and encrypted IPSec certificates of the MESH network:

```bash
taglio@trimurti:~/Work/redama/ipsec$ find . -name "*.p12"
./indra/RT-01.cat.telecomlobby.com.p12
./uma/fr.telecomlobby.com.p12
./shiva/jp.telecomlobby.com.p12
./varuna/bg.telecomlobby.com.p12
./ganesha/uk.telecomlobby.com.p12
./saraswati/us.telecomlobby.com.p12
./vishnu/au.telecomlobby.com.p12
./durga/de.telecomlobby.com.p12
./calli/ixp.telecomlobby.com.p12
taglio@trimurti:~/Work/redama/ipsec$ 
```

Now simply start the `console` script with the `-CHR` option:

```bash
taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ ./console 
./console have to be used with the following options 			
-I  -> local domain name [x]			
-N  -> newhost [o]			
-G  -> git pull [o]			
-S  -> scripts [o] 			
-D  -> dyndnspop [o] 			
-F  -> single file update [o] 			
-C  -> cleanlast [o] 			
-RS -> repository ssh update [o] 			
-K  -> new IKED pk12 archive [o] 			
-T  -> tmux and SSH to all openbsd MESH hosts [o] 			
-M  -> Mikrotik RouterOS add new OpenBSD [o] 			
-E  -> Ubiquiti EdgeOS add new OpenBSD [o] 			
-P  -> Mass syspatch OpenBSD hosts [o] 			
-Z  -> Global network domains setup [o] 			
-OM -> Mikrotik RouterOS ospf-in/out filter [o] 			
-OE -> EdgeOS ospf-in/out filter [o] 			
-OO -> OpenBSD ospf filter [o] 			
-U  -> update the workstation's user EdDSA certificate [o] 			
-NO -> newospf configuration [o] 			
-PF -> new firewall configuration [o] 			
-CHR -> new RouterOS Cloud Hosted Router istance [o] 			

taglio@trimurti:~/Work/telecom.lobby/OpenBSD$  
```

[![asciicast](https://asciinema.org/a/450247.svg)](https://asciinema.org/a/450247)

This is the video of the complete routine about the OpenBSD peers. Next we've got to add the new Cloud Hosted Router to the other Mikrotik instances and EdgeOS.

### Routine maintenance

![](https://thumbs.dreamstime.com/b/routine-maintenance-mechanism-golden-metallic-cogwheels-glow-effect-d-rendering-concept-gears-illustration-114332777.jpg)

#### New monthly EdDSA workstation key

One of the important routine maintenance operation that we shall do in our network is the renew of the `EdDSA` key for the workstation's user authorized by the [CA server](https://github.com/redeltaglio/OpenBSD-private-CA).

Use the `console` script as usual following those operations:

```shell
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ ./console -I telecom.lobby -U
mv: cannot stat '/home/riccardo/.ssh/id_ed25519-cert.pub': No such file or directory
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/riccardo/.ssh/id_ed25519): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/riccardo/.ssh/id_ed25519
Your public key has been saved in /home/riccardo/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:IE3Ad3KZdNWitnj0lIjaqLq2SVCNPR52G1UDZHttIKA taglio@
The key's randomart image is:
+--[ED25519 256]--+
|   ...o+B==...   |
|   +.+oo=+ +. .  |
|  o E.=+...ooo   |
| . o = +..=.o    |
|.   . .+S+ +     |
| .    o o o .    |
|  .  .   .       |
| ....            |
| .=+             |
+----[SHA256]-----+
Password:
Type the mounted FAT32 pen drive directory:/media/riccardo/0903-C8DC
Ready? type 1
```

This action will change also the public key specified in the `installation/install-vps.conf` used in the system operative installation process, so remember to upgrade the repository.

Next take the pen drive to the CA server physic station and run the setup_ca script with the correct option `setup_ca upuser`. Return it to the workstation and type `1`. 

#### New yearly IPsec certificate to hosts and management

![](https://github.com/redeltaglio/OpenBSD/raw/master/img/1_UytIyLrrKVK9q9hVkuRNyA.gif)

First of all remember that certificate of the IPsec network got a deadline. They are created from the CA server with a life span of 365 days. One option of our `console` script simply printout the creation and deadline date with a comparison with the current date time in [GMT](https://en.wikipedia.org/wiki/Greenwich_Mean_Time) and in [Unix epoch](https://en.wikipedia.org/wiki/Unix_time).

```bash
taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ ./console -I telecom.lobby -KD
Current GMT time is: Feb 13 21:54:15 2022 GMT
Current epoch time is: 1644789255
Looking at OpenBSD hosts...
IPsec SSL certificate deadline of ganesha is: Feb 11 23:52:24 2023 GMT
IPsec SSL certificate epoch deadline of ganesha is: 1676159544
IPsec SSL certificate deadline of saraswati is: Feb 12 09:19:45 2022 GMT
IPsec SSL certificate epoch deadline of saraswati is: 1644657585
saraswati IPsec SSL certificate has to be upgraded
IPsec SSL certificate deadline of shiva is: Feb 10 18:14:23 2022 GMT
IPsec SSL certificate epoch deadline of shiva is: 1644516863
shiva IPsec SSL certificate has to be upgraded
IPsec SSL certificate deadline of varuna is: Apr 12 15:46:57 2022 GMT
IPsec SSL certificate epoch deadline of varuna is: 1649778417
IPsec SSL certificate deadline of vishnu is: Jun 20 13:03:23 2022 GMT
IPsec SSL certificate epoch deadline of vishnu is: 1655730203
IPsec SSL certificate deadline of bhagavati is: Aug 25 14:58:55 2022 GMT
IPsec SSL certificate epoch deadline of bhagavati is: 1661439535
IPsec SSL certificate deadline of xolotl is: Jan  2 13:50:38 2023 GMT
IPsec SSL certificate epoch deadline of xolotl is: 1672667438
IPsec SSL certificate deadline of umnyama is: Jan  3 08:05:22 2023 GMT
IPsec SSL certificate epoch deadline of umnyama is: 1672733122
Looking at Mikrotik RouterOS hosts...
IPsec SSL certificate deadline of calli is: nov 15 17:47:04 2022
IPsec SSL certificate epoch deadline of calli is: 1668530824
Looking at Ubiquiti EdgeOS hosts...
IPsec SSL certificate deadline of indra is: Feb 11 22:22:52 2023 GMT
IPsec SSL certificate epoch deadline of indra is: 1676154172
 

```

Once you find some certificates expired fired up the CA server instance change the name to the old one, revoke it and create a new one has you have done to create it. Remember that this control operation has been done upon OpenBSD, RouterOS and EdgeOS hosts connected in our network.

Next with the tool paste the filesystem position of the new PK12 file that was exported as usual with the password `123456789`, it will upgrade the correspondent host files:

- `/etc/iked/local.pub` the SSL public key used with [iked(8)](https://man.openbsd.org/iked).
- `/etc/iked/private/local.key` the SSL private key.
- `/etc/iked/certs/$publichost.crt` the SSL [X509](https://en.wikipedia.org/wiki/X.509) certificate.

Onto Mikrotik it will delete the old certificate, import the new one and update the correspondent ipsec identity.

```bash
/certificate remove [/certificate find where name=${publichost}]
/certificate import passphrase=123456789 file-name=$pk12 name=${publichost}
/ip ipsec identity set [/ip ipsec identity find where certificate=${publichost}] certificate=${publichost}
```

Onto EdgeOS it will copy the new X509 certificate and perform those [commands](https://wiki.strongswan.org/projects/strongswan/wiki/ipseccommand) into [strongSwan](https://www.strongswan.org/):

- ipsec rereadall
- ipsec reload



#### Add new host to PF

Another simple maintenance process is add another host to one table of `pf`. For example:

[![OpenBSD MESH IPSec network: PF manteinance](https://asciinema.org/a/426193.png)](https://asciinema.org/a/426193)

#### New GRE subnet

Another maintenance that we've got to do is add another [gre(4)](https://man.openbsd.org/gre.4) subnet in case ip addressing is going to finish. For example let's add `10.10.9.0/24` to the existing `10.10.10.0/24`:

Reset `gre7058` into the `telecomlobby.com.zone` onto the master domain name server and reload it:

```bash
root@ganesha:/var/nsd/zones/master# sed -i "s|gre7058.*|gre7058 IN TXT \"255\"|" telecomlobby.com.zone
```

Add the new prefix into the [pf(4)](https://man.openbsd.org/pf.4) table `src/etc/pf.conf.table.locals` from the workstation and upload to the repository, the use the `console` script to update all the systems and reload firewall globally.

```bash
taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ echo 10.10.9.0/24 >> src/etc/pf.conf.table.locals
taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ 

```

As `4 of January 2022` both setup_node and console scripts question to the user what is the subnet to use:

```bash
umnyama# sh setup_node -I                                                                Type 1 to use /tmp/config.ini 
0
Type the current gre subnet 
10.10.9
```

#### Remote upgrade

![](https://redama.es/Imagenes/varuna_shell.png)

If the VPS provider got the option to install OpenBSD, a custom ISO or hasn't the solution is always the same, use `sysupgrade`.

The upgrade our git repository and launch the `upgrade.sh` script. Remember to wait a couple of days after the [release announce](https://www.openbsd.org/69.html) is published by [Theo de Raddt](https://www.theos.com/deraadt/).

Under `tools/` directory you can find different scripts useful to adapt configuration between releases. Always keep in mind to carefully read what the OpenBSD crew have to explain to us, power users, about changes. For example here you are the one about the `7 RELENG`:

- [OpenBSD 7.0](https://www.openbsd.org/70.html)

Next you can call them in a massive way as usual using the `console` script from the workstation:

```bash
taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ ./console 
./console have to be used with the following options 			
 			
-I   -> local domain name [x]			
-N   -> newhost [o]			
-G   -> git pull [o]			
-S   -> scripts [o] 			
-D   -> dyndnspop [o] 			
-F   -> single file update [o] 			
-C   -> cleanlast [o] 			
-RS  -> repository ssh update [o] 			
-K   -> new IKED pk12 archive [o] 			
-T   -> tmux and SSH to all openbsd MESH hosts [o] 			
-M   -> Mikrotik RouterOS add new OpenBSD [o] 			
-E   -> Ubiquiti EdgeOS add new OpenBSD [o] 			
-P   -> Mass syspatch OpenBSD hosts [o] 			
-Z   -> Global network domains setup [o] 			
-OM  -> Mikrotik RouterOS ospf-in/out filter [o] 			
-OE  -> EdgeOS ospf-in/out filter [o] 			
-OO  -> OpenBSD ospf filter [o] 			
-U   -> update the workstation's user EdDSA certificate [o] 			
-NO  -> newospf configuration [o] 			
-PF  -> new firewall configuration [o] 			
-CHR -> new RouterOS Cloud Hosted Router istance [o] 			
-7   -> changes to 7.0 release [o] 			

taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ ./console -I telecom.lobby -7
Connecting to ganesha
Connection to ganesha.telecom.lobby closed.
Connecting to saraswati
Connection to saraswati.telecom.lobby closed.
Connecting to shiva
Connection to shiva.telecom.lobby closed.
Connecting to varuna
Connection to varuna.telecom.lobby closed.
Connecting to durga
Connection to durga.telecom.lobby closed.
Connecting to vishnu
Connection to vishnu.telecom.lobby closed.
Connecting to bhagavati
Connection to bhagavati.telecom.lobby closed.
taglio@trimurti:~/Work/telecom.lobby/OpenBSD$

```

#### Generate custom `install.conf` and `disklabel` for new host

Sometimes it would be interesting that end user generate files in the `installation/` because of different `VPS` provider specifications.  `console` script got `-CI` as the correct option to do it in a simple way:

```bash
taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ ./console -I telecom.lobby -CI
Build IPv4 static custom installation template? yes/no: yes
Type IPv4 address for vio0: 160.119.248.111
Type netmask for vio0: 255.255.255.0
Type default IPv4 route: 160.119.248.1  
Build custom size disklabel? yes/no: yes
Type size in GB: 20
Files added, please update the repository and remember to use https://bit.ly/3HD0Wne
taglio@trimurti:~/Work/telecom.lobby/OpenBSD$
```

In this case remember that in the remote `VNC` web console you've got to configure the same static IPv4 and DNS in order to obtain connectivity to Internet:

```bash
# ifconfig vio0 160.119.248.111 netmask 255.255.255.0 up
# route add 0.0.0.0/0 160.119.248.1
# echo nameserver 8.8.8.8 > /etc/resolv.conf
```

Next to start the installation process as usual:

```bash
# cd /tmp
# ftp -o install.conf https://bit.ly/3HD0Wne
# install -af /tmp/install.conf
```

#### Delete a VPS instance that you own

1. Delete the VPS instance from the provider console.
2. Use `tools/clean_last` in every OpenBSD VPS, better from the web VNC console, adding the correct `gre` interface as first and only argument.
3. Eliminate the entries about in the public and local DNS daemon.

## Possible appliances

Let's start discussing how we can boost our presence in Internet using that guerrilla MESH system that guaranty our privacy and security on the web. My first project is regarding a website replicated over different countries in all the languages over the world. Something very important to obtain maximum results about clients, about web goods sell, about be recognized over it and about whatever we want to obtain searching for visibility.

I've got to cases, one is about the correct information about the modern slavery network transmitted by electromagnetic weapons to the marginal and worker class of many countries, also Europeans. The other is to have got a great site about my professional work, Redama, a wireless ISP but also an Internet website that sold security focused end devices and gateways.   

Next some daemons that we've got to configure to start a new world of applications, remember that my goals are:

- a distributed spider to search for clients for my business and to catalog emails, fax numbers and contacts of United Nations personal that work fighting the modern slavery. I'm a private investigator and I've got to massively denunciate the remote neural control and interference to the brain facility.
- a multi language web site, one for my work the other for my page of public compliant. 
- a massive system of alert by www, smtpd and SIP.

### Content delivery network

#### PowerDNS

![](https://jpmens.net/media/2015b/powerdns-geoip.png)

[PowerDNS](https://en.wikipedia.org/wiki/PowerDNS) is a [DNS server](https://en.wikipedia.org/wiki/Name_server) that we are going to use because of it [GeoIP](https://en.wikipedia.org/wiki/Internet_geolocation) [features](https://doc.powerdns.com/authoritative/backends/geoip.html). Using that we will reply to dns request in different ways depending on the geographical position of the source IP. Onto the position in the world map of our client. Why? To load balance  requests and to archive a lot of features more.

The [PowerDNS module](https://doc.powerdns.com/authoritative/backends/geoip.html) about geoip it's not included in the OpenBSD package, so we've got to compile that daemon and run it under a [chroot](https://en.wikipedia.org/wiki/Chroot) environment to be sure to not add a security problem in our network. What we're going to run in our VPS secure guerrilla network is [GeoDNS](https://jpmens.net/2015/11/12/geodns-with-powerdns-geoip-back-end/) being part of a content delivery network prepared to serve data despite the geographic position of the client.

Our geographic aware CDN will work upon the [continent](https://en.wikipedia.org/wiki/Continent) definition that included:

- **AF**, [Africa](https://en.wikipedia.org/wiki/Africa)
- **AN**, [Antarctica](https://en.wikipedia.org/wiki/Antarctica) 
- **AS**, [Asia](https://en.wikipedia.org/wiki/Asia)
- **EU**, [Europe](https://en.wikipedia.org/wiki/Europe)
- **NA**, [North America](https://en.wikipedia.org/wiki/North_America)
- **OC**, [Oceania](https://en.wikipedia.org/wiki/Oceania) 
- **SA**, [South America](https://en.wikipedia.org/wiki/South_America)

We are going to use some ASCII texts with connection between [ISO-3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) country code and continent nomenclature. 

Next feature for example can be serving a web page in a different language depending on the language used in the web browser of our client but this is another think.

![Political Map](https://upload.wikimedia.org/wikipedia/commons/5/55/Political_Map_of_the_World.png)

```shell
taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ ./console -I telecom.lobby -Z
Type the two .com domains (the principle and the secondary) divided by a comma: 
telecomlobby.com,9-rg.com

telecomlobby.com: 
   Name Server: JP.TELECOMLOBBY.COM
   Name Server: UK.TELECOMLOBBY.COM
   Name Server: US.TELECOMLOBBY.COM

DNSSEC not enable onto telecomlobby.com!
<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>

9-rg.com: 
   Name Server: JP.TELECOMLOBBY.COM
   Name Server: UK.TELECOMLOBBY.COM
   Name Server: US.TELECOMLOBBY.COM

DNSSEC enabled onto 9-rg.com!
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
LAT --> 51
LONG --> -0

GROUP --> 34
BACKBONE OSPFAREA 0.0.0.0
GEO OSPFAREA --> 0.0.3.4
CONTINENT --> EU


US	+415100-0873900	America/Chicago	Central (most areas)

{
  "ip": "155.138.247.27",
  "hostname": "us.telecomlobby.com",
  "city": "Dallas",
  "region": "Texas",
  "country": "US",
  "loc": "32.7831,-96.8067",
  "org": "AS20473 The Constant Company, LLC",
  "postal": "75201",
  "timezone": "America/Chicago",
}
LAT --> 32
LONG --> -96

GROUP --> 12
BACKBONE OSPFAREA 0.0.0.0
GEO OSPFAREA --> 0.0.1.2
CONTINENT --> NA


JP	+353916+1394441	Asia/Tokyo

{
  "ip": "139.180.206.19",
  "hostname": "jp.telecomlobby.com",
  "city": "Tokyo",
  "region": "Tokyo",
  "country": "JP",
  "loc": "35.6895,139.6917",
  "org": "AS20473 The Constant Company, LLC",
  "postal": "101-8656",
  "timezone": "Asia/Tokyo",
}
LAT --> 35
LONG --> 139

GROUP --> 56
BACKBONE OSPFAREA 0.0.0.0
GEO OSPFAREA --> 0.0.5.6
CONTINENT --> AS


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
LAT --> 42
LONG --> 23

GROUP --> 34
BACKBONE OSPFAREA 0.0.0.0
GEO OSPFAREA --> 0.0.3.4
CONTINENT --> EU


DE	+5230+01322	Europe/Berlin	Germany (most areas)

{
  "ip": "45.63.116.141",
  "hostname": "de.telecomlobby.com",
  "city": "Frankfurt am Main",
  "region": "Hesse",
  "country": "DE",
  "loc": "50.1155,8.6842",
  "org": "AS20473 The Constant Company, LLC",
  "postal": "60306",
  "timezone": "Europe/Berlin",
}
LAT --> 50
LONG --> 8

GROUP --> 34
BACKBONE OSPFAREA 0.0.0.0
GEO OSPFAREA --> 0.0.3.4
CONTINENT --> EU


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
LAT --> -33
LONG --> 151

GROUP --> 56
BACKBONE OSPFAREA 0.0.0.0
GEO OSPFAREA --> 0.0.5.6
CONTINENT --> OC


ES	+4024-00341	Europe/Madrid	Spain (mainland)

{
  "ip": "188.213.5.62",
  "hostname": "mad.telecomlobby.com",
  "city": "Madrid",
  "region": "Madrid",
  "country": "ES",
  "loc": "40.4165,-3.7026",
  "org": "AS59432 GINERNET S.L.",
  "postal": "28037",
  "timezone": "Europe/Madrid",
}
LAT --> 40
LONG --> -3

GROUP --> 34
BACKBONE OSPFAREA 0.0.0.0
GEO OSPFAREA --> 0.0.3.4
CONTINENT --> EU

```

Using the `console` script from the workstation give us a global vision of our IPSec network. It's important because of management of the DNS servers and the geo-ip feature.

I use two domain names because administrating the NS pulls which others.

I've divided world into three groups depending onto GPS system. `console` give you at what group is pertaining every host connected to our guerrilla network. Next we will create three containers in which we will put those hosts to create three pulls of name servers. After depending onto the geographical position of the client doing the query the system will reply in a manner or another using the `powerdns` geo-ip feature.

In the GeoDNS server dynamic choose our `console` script will save data into a [SQLite](https://www.sqlite.org/index.html) database, which is initialized by a template found in `src/openbsd` directory. Schema is very simple:

```sqlite
PRAGMA foreign_keys = 1;

CREATE TABLE domains (
  id                    INTEGER PRIMARY KEY,
  name                  VARCHAR(255) NOT NULL COLLATE NOCASE,
  ns34                  VARCHAR(40) DEFAULT NULL,
  ns12                  VARCHAR(40) DEFAULT NULL,
  ns56                  VARCHAR(40) DEFAULT NULL,
  dnssec                TINYINT DEFAULT 0,
  dnssec_keyid          VARCHAR(5) DEFAULT NULL,
  last_update           INTEGER DEFAULT NULL,
  last_check            INTEGER DEFAULT NULL,
);
```

Another important feature is that our tool give us information withing the [whois database](https://en.wikipedia.org/wiki/WHOIS) if the suite of extensions [DNSSEC](https://en.wikipedia.org/wiki/Domain_Name_System_Security_Extensions) is enable from the registrant. 	

#### DNSSEC

![](https://www.researchgate.net/profile/Nicola-Zannone/publication/326276803/figure/fig1/AS:648934477283337@1531729444191/An-overview-of-DNSSEC.png)

Look at `dnssec_sign.sh` script into the `Bin` directory of the `root` user:

```shell
#!/bin/ksh

DOMAIN=$1
ZONEDIR="/var/nsd/zones/master"
DNSSECDIR="/var/nsd/etc/dnssec"


[[ $# -eq 0 ]] && \
	print "No Arguments" && \
	exit


[[ $2 == "clean" ]] && \
	rm $DNSSECDIR/*$DOMAIN* && \
	rm $ZONEDIR/$DOMAIN.zone.signed && \
	exit
	
[[ $1 == "cleanall" ]] && \
	rm -rf $DNSSECDIR/* && \
	exit

[[ $2 == "reload" ]] && \
	ZSK=$(basename $(grep -r "`grep '(zsk)' *.signed |cut -f3-10`" $DNSSECDIR/K$DOMAIN.*.key | cut -d ':' -f1) .key) && \
	KSK=$(basename $(grep -r "`grep '(ksk)' *.signed |cut -f3-10`" $DNSSECDIR/K$DOMAIN.*.key | cut -d ':' -f1) .key) && \

	ldns-signzone -n -p -s $(head -n 1000 /dev/random | sha1 | cut -b 1-16) -f $ZONEDIR/$DOMAIN.zone.signed $DOMAIN.zone $DNSSECDIR/$ZSK $DNSSECDIR/$KSK && \
	nsd-control reload $DOMAIN && \
	nsd-control notify $DOMAIN && \
	exit

cd $ZONEDIR

export ZSK=`ldns-keygen -a RSASHA1-NSEC3-SHA1 -b 1024 $DOMAIN`
export KSK=`ldns-keygen -k -a RSASHA1-NSEC3-SHA1 -b 2048 $DOMAIN`

[[ -e $ZSK.ds ]] && rm $ZSK.ds 
[[ -e $KSK.ds ]] && rm $KSK.ds
mv $ZSK.* $DNSSECDIR && mv $KSK.* $DNSSECDIR
chown root:_nsd $DNSSECDIR/* && chmod ug+r,o-rwx $DNSSECDIR/* 

# now it's time to create the .signed zone file
ldns-signzone -n -p -s $(head -n 1000 /dev/random | sha1 | cut -b 1-16) -f $ZONEDIR/$DOMAIN.zone.signed $DOMAIN.zone $DNSSECDIR/$ZSK $DNSSECDIR/$KSK

# and here are our DS records to give to our registrar
ldns-key2ds -n -1 $DOMAIN.zone.signed && ldns-key2ds -n -2 $DOMAIN.zone.signed
```

I've got the two domains registered with [dreamhost](https://en.wikipedia.org/wiki/DreamHost) , they have got a section in them forum with the rules to use DNSSEC:

- [DNSSEC overview](https://help.dreamhost.com/hc/en-us/articles/219539467-DNSSEC-overview)

Let's see the output of our `dnssec_sign.sh` script:

```shell
root@ganesha:/var/nsd/zones/master# dnssec_sign.sh 9-rg.com 
9-rg.com.       86400   IN      DS      61419 7 1 2b2a9ff48c50d380fb8a1dfd98441ae346d69c02
9-rg.com.       86400   IN      DS      61419 7 2 ae0e5e3d0ab5b6d4d36450356f1d77dbaa8b156e29aac8b8f64d448d3d054f4b
root@ganesha:/var/nsd/zones/master# 
```

This output contain the informations that we shall to publish in a dedicated support ticket.

When provide add the informations about DNSSEC into the whois database you can find them using this command:

```shell
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ whois 9-rg.com | grep DNSSEC
   DNSSEC: signedDelegation
   DNSSEC DS Data: 22020 7 2 548BDCFE84669FFA8783E753BD1A8279C5374DF32707D5CB6B74445BCC733F5E
   DNSSEC DS Data: 22020 7 1 728023CADD4CDF96909000A9E79BEF424B3677A0
DNSSEC: signedDelegation
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ 
	
```

Change the `nsd.conf` file and specify the new signed zone:

```shell
zone:
name: "9-rg.com"
zonefile: "master/9rgcom.zone.signed"
include-pattern: "telecomlobby"
```

And reload the server:

```shell
root@ganesha:/var/nsd/etc# rcctl restart nsd                                                                                                                      
nsd(ok)
nsd(ok)
root@ganesha:/var/nsd/etc# 
```



![](https://github.com/redeltaglio/OpenBSD/raw/master/img/dnskey_dnssec.png)

### Wireless Internet Service Provider

#### Mikrotik LTE routers and customers

![](https://github.com/redeltaglio/OpenBSD/raw/master/img/3fe10498-bb07-4ca3-972f-bd62b53026b0.jpeg)

Two types, one are end users the other routers to our network that create WISP point of presence, one appliance of my network the other one LTE rural customer. 

In the two cases CPE is a [Mikrotik LHG LTE kit](https://mikrotik.com/product/lhg_lte_kit).

First of all I want to underline that lines of routers connected to our network to form a little POP in the WISP appliance are connected to the Internet using a provider that give access to it using NAT. Taking this in consideration will perform in different steps:

- `/ip cloud set ddns-enable=yes` means enable a dynamic host using a Mikrotik service that point to external IP address of the connection. For example `d6af0e9e2591.sn.mynetname.net`.
- IPSec connection will use [NAT traversal](https://en.wikipedia.org/wiki/NAT_traversal) feature because its bare nature, router is behind NAT! Others have to accept incoming connection to the `4500 UDP` port from the dynamic host that we've just configured.
- Use `src/etc/pf.conf.table.lte` to add the new LTE WISP point of presence.
- Because its nature behind NAT use [l2tp](https://en.wikipedia.org/wiki/Layer_2_Tunneling_Protocol) to add a public IPv4 address to it. But you can ever do it in IPv6 to not consume an IPv4 from your pool. Remember that this IPSec and L2TP tunnel will be created using one of our Mikrotik endpoints. Be careful to use as the Internet gateway for the workstation LAN the same endpoint. This machine will be not configured in the automatic IPSec configuration process until the end when it will be.

Next start to configure the new LTE last mile Internet access router, in my case public host is `mir.telecomlobby.com`, internal host is `thangka.telecom.lobby` and router id is `192.168.13.10`:

1. ```bash
   root@ganesha:/var/nsd/zones/master# cat telecomlobby.com.zone | grep ipsec20     
   ipsec20591              IN TXT "uk:ganesha;us:saraswati;jp:shiva;es:indra;bg:neo;au:vishnu;mad:bhagavati;ixp:calli;br:xolotl;za:umnyama;mir:thangka;"
   root@ganesha:/var/nsd/zones/master# 
   ```

2. ```bash
   taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ dig A mir.telecomlobby.com @8.8.8.8 +short
   188.213.5.222
   taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ dig -x 188.213.5.222 +short
   mir.telecomlobby.com.
   taglio@trimurti:~/Work/telecom.lobby/OpenBSD$ 
   ```

3. 

### Hamradio passive and active point of presence

#### Linux Rasberry and HackRF

## Annexed

### OpenBSD, Mikrotik and EdgeOS firewall

Let's explain how firewall does it works in our network. We shall start with address lists, that takes different names depending what system operative does implement them:

- OpenBSD, [pf(4)](https://man.openbsd.org/pf), [tables](https://www.openbsd.org/faq/pf/tables.html)
- Mikrotik RouterOS, [ip firewall](https://help.mikrotik.com/docs/display/ROS/Firewall), [address-list](https://wiki.mikrotik.com/wiki/Manual:IP/Firewall/Address_list). Remember that Mikrotik use [netfilter iptables](https://www.netfilter.org/).
- Ubiquiti EdgeOS, [firewall group](https://help.ui.com/hc/en-us/articles/218889067-EdgeRouter-How-to-Create-a-Guest-LAN-Firewall-Rule). EdgeOS is a modified version of [VyOS](https://vyos.io/), better saying is also based upon [iptables(8)](https://manpages.debian.org/jessie/iptables/iptables.8.en.html).

Those are the address lists that we use:

**clientes** where we add the public IPv4 assigned to our customers of the WISP service, customers could served with [pppoe](https://en.wikipedia.org/wiki/Point-to-Point_Protocol_over_Ethernet) daemon or [l2tp](https://en.wikipedia.org/wiki/Layer_2_Tunneling_Protocol):

```bash
188.213.5.220/32
188.213.5.221/32
188.213.5.222/32
188.213.5.223/32
188.213.5.240/32
188.213.5.241/32
188.213.5.242/32
188.213.5.243/32
188.213.5.244/32
188.213.5.245/32
188.213.5.246/32
188.213.5.247/32
188.213.5.236/32
188.213.5.237/32
188.213.5.238/32
188.213.5.239/32
5.134.119.165/32
```

**users** where we add local private subnet that could be translated with nat to go outside in the Internet:

```bash
172.16.16.0/24
172.16.17.106
172.16.18.0/24
172.16.19.0/24
172.16.23.0/24
```

**ipsec** that are the public IPv4 of others machines connected to our network with IPsec, it grow automatically with our program:

```bash
2.139.174.201
5.134.119.135
45.63.116.141
78.141.201.0
94.72.143.163
139.180.165.223
139.180.206.19
155.138.247.27
160.119.248.111
188.213.5.62
216.238.100.26
```

A special list is **roadwarrior** that contains domain names and it used only in CHR instances. In customers we use [ip cloud](https://help.mikrotik.com/docs/display/ROS/Cloud) to update the dynamic dns entrance. 

```bash
[admin@cornus-LHG] /ip cloud> export
/ip cloud set ddns-enabled=yes ddns-update-interval=1m
[admin@cornus-LHG] /ip cloud> pr
          ddns-enabled: yes
  ddns-update-interval: 1m
           update-time: yes
        public-address: 79.116.87.98
              dns-name: d6af0ec1ec8d.sn.mynetname.net
                status: updated
               warning: Router is behind a NAT. Remote connection might not work.
[admin@cornus-LHG] /ip cloud> 

```

Another kind of list used by OpenBSD and Mikrotik RouterOS is the list of interfaces, them purposes are simplify the rules sets of firewalls.

**gre** interface list in RouterOS, that grown dynamically with out scripts:

```bash
[taglio@calli.telecom.lobby] /interface list> export
/interface list
add name=gre
/interface list member
add interface=gre-tunnel1 list=gre
add interface=gre-tunnel2 list=gre
add interface=gre-tunnel3 list=gre
add interface=gre-tunnel4 list=gre
add interface=gre-tunnel5 list=gre
add interface=gre-tunnel6 list=gre
add interface=gre-tunnel7 list=gre
add interface=gre-tunnel8 list=gre
add interface=gre-tunnel9 list=gre
add interface=gre-tunnel10 list=gre
[taglio@calli.telecom.lobby] /interface list> 
```

In OpenBSD interfaces lists are created using the `groups` flavor, that could configured in the [hostname.if(5)](https://man.openbsd.org/hostname.if.5) file: 

```bash
root@ganesha:/var/www/htdocs/es.telecomlobby.com/radio_aficionado# ifconfig gre9
gre9: flags=8051<UP,POINTOPOINT,RUNNING,MULTICAST> mtu 1392
        description: br.telecomlobby.com
        index 24 priority 0 llprio 6
        keepalive: timeout 5 count 2
        encap: vnetid none txprio payload rxprio packet
        groups: gre
        status: active
        tunnel: inet 78.141.201.0 --> 216.238.100.26 ttl 64 nodf ecn
        inet 10.10.10.62 --> 10.10.10.61 netmask 0xfffffffc
root@ganesha:/var/www/htdocs/es.telecomlobby.com/radio_aficionado# 
```

### Add a new service to the network

​	
