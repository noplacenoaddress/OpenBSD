# OpenBSD on demand mesh host

![Puffy rules](https://www.openbsd.org/art/puffy/ppuf800X725.gif)

The final goal is to add a full configured, secure by default, encrypted mesh node to an existing network. 

It will replicate all the services on the network, and it can be deleted without loosing any data.

Especially focused above security in every ISO/OSI pile level. 

Applications are multiples, from bypass the European [ECHELON](https://en.wikipedia.org/wiki/ECHELON), an enormous sniffer from some ISP, or the great firewall in China, to create very secure not logged chat, to dynamic traditional services that will move from an host to another in a total transparent mode to the final user.

I'm an addicted of privacy and security and I'm very tired about the modern slavery network transmitted by weapons from the European elite. 

*Vatican and Aristocracy are totally guilty about the recent destroy of democracy.*

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

Next use the script `ipsec_newpubkey` to add the new public IPsec key to the `src/etc/iked/pubkeys/ufqdn` directory update the repository and use the console script in the right way:



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
root@neo:/home/taglio/Sources/Git/OpenBSD# sh setup_node                                                                                                                                                                                                  
changing installurl
Go ahead type 1 
```

After some points the program give us the root ssh `ed25519` key of the new host. That is [EdDSA](https://en.wikipedia.org/wiki/EdDSA) in [public key cryptography](https://en.wikipedia.org/wiki/Public-key_cryptography).  Update the repository:

``` shell
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ sed -i '/durpa.telecom.lobby/d' src/etc/ssh/remote_install/authorized_keys 
riccardo@trimurti:~/Work/telecom.lobby/OpenBSD$ echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHfCxPKwUqEG9JaEaK6uqFDfDMFYFTblLEWPekGh8CAn root@durpa.telecom.lobby" >> src/etc/ssh/remote_install/authorized_keys 
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

#### Remote upgrade

![](https://redama.es/Imagenes/varuna_shell.png)

If the VPS provider got the option to install OpenBSD, a custom ISO or hasn't the solution is always the same, use `sysupgrade`.

The upgrade our git repository and launch the `upgrade.sh` script. Remember to wait a couple of days after the [release announce](https://www.openbsd.org/69.html) is published by [Theo de Raddt](https://www.theos.com/deraadt/).

#### Registered domains application

Start with two VPS, one master in DNS service and the other slave. All the others services will be replicated. Some providers doesn't permit the installation of OpenBSD as a default option so install Linux and then rewrite the disc with `dd` as explained:

#### Possible applications

Let's start discussing how we can boost our presence in Internet using that guerrilla MESH system that guaranty our privacy and security on the web. My first project is regarding a website replicated over different countries in all the languages over the world. Something very important to obtain maximum results about clients, about web goods sell, about be recognized over it and about whatever we want to obtain searching for visibility.

I've got to cases, one is about the correct information about the modern slavery network transmitted by electromagnetic weapons to the marginal and worker class of many countries, also Europeans. The other is to have got a great site about my professional work, Redama, a wireless ISP but also an Internet website that sold security focused end devices and gateways.   

Nice Regards,

Riccardo `<taglio>` Giuntoli.