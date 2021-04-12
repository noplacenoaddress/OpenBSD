# OpenBSD on demand mesh host

![Puffy rules](https://www.openbsd.org/art/puffy/ppuf800X725.gif)

The final goal is to add a full configured, secure by default, encrypted mesh node to an existing network. 

It will replicate all the services on the network, and it can be deleted without loosing any data.

Especially focused above security in every ISO/OSI pile level. 

Applications are multiples, from bypass the European ECHELON, an enormous sniffer from some ISP, or the great firewall in China, to create very secure not logged chat, to dynamic traditional services that will move from an host to another in a total transparent mode to the final user.

I'm an addicted of privacy and security and I'm very tired about the modern slavery network transmitted by weapons from the European elite. 

**Vatican and Aristocracy are totally guilty about the recent destroy of democracy.**

### Install procedure

First of all you've got to rent a VPS in one service provider, there are a lot on Internet a great resource to find the correct one is this website:

- [Low End Box - Cheap VPS, Dedicated Servers and Hosting Deals](https://lowendbox.com/)

Some that I use or I've used:

- [SSD VPS Servers, Cloud Servers and Cloud Hosting by Vultr - Vultr.com](https://www.vultr.com/)
- [AlphaVPS - Cheap and Reliable Hosting and Servers](https://alphavps.com/)
- [VPS Hosting in Europe and USA. Join VPS2DAY now!](https://www.vps2day.com/)
- [Liveinhost Web Services &#8211; The Best Web Hosting | Fast Professional Website Hosting Services](https://www.liveinhost.com/)

Try to understand that we've got to build a network of VPS interconnected site to site between everyone with IPsec and every host is plug and play, I mean that we can add or remove VPS just running the software in this repository. First of all it is important to understand that we can use this design in two different application, one will use registered domains the other will use free dns services. Goal for everyone is security trough simplicity, open source design and the correct use and implementation of robust compliance protocols and daemons. The system operative is [OpenBSD](https://www.openbsd.org/) but later we will use also [Alpine Linux](https://alpinelinux.org/). At that point the goal will be interoperability and the search of near perfect TCP/IP throughput. Another goal will be the use of ARM64 mobile devices also based up Alpine, my favorite one is:

-  [PinePhone](https://pine64.com/product-category/pinephone/?v=0446c16e2e66)

Another interesting end device based upon open hardware that use [LoRa](https://en.wikipedia.org/wiki/LoRa) and GSM is:

- [ESPboy](https://www.espboy.com/)

#### VPS without OpenBSD as system available

Many times we've got to resolve problems like the one where OpenBSD isn't listed as a default system operative in our remote KVM administration web console. This isn't our death.

First of all install a classic Linux, like Debian for example. Next ssh to the new machine with the credentials provided. Next download the latest stable `miniroot` image into the root and write it to the start of our virtual disk, in linux normally  it will be `vda`.

```sh
# wget https://cdn.openbsd.org/pub/OpenBSD/6.8/amd64/miniroot68.img
# dd if=miniroot68.img of=/dev/vda bs=4M
```

 After the successful write to the virtual disk we've got to reboot the machine but we will do it in a particular way using the `proc` filesystem:

```shell
# echo s > /proc/sysrq-trigger
# echo b > /proc/sysrq-trigger 
```

Next reopen the KVM web console and the installation process of OpenBSD will start. Interrupt it choosing for the (S)hell option and:

```shell
# dhclient vio0
# cd /tmp && ftp -o install.conf https://bit.ly/3mEYdAo
# install -af /tmp/install.conf
# reboot
```

After the reboot login in the new node and change the password and upgrade the system with `syspatch`.

#### First steps

Next that we will have a running fresh and patched OpenBSD system let's start to configure our guerrilla MESH node. Install the git package:

```shell
neo# pkg_add git
neo$ mkdir -p Sources/Git && cd Sources/Git
neo$ git clone https://github.com/noplacenoaddress/OpenBSD.git
```



#### Registered domains application

Start with two VPS, one master in DNS service and the other slave. All the others services will be replicated. Some providers doesn't permit the installation of OpenBSD as a default option so install Linux and then rewrite the disc with `dd` as explained:



Nice Regards,

Riccardo `<taglio>` Giuntoli.