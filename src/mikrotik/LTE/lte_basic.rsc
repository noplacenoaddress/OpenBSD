/interface l2tp-client
add add-default-route=yes allow-fast-path=yes connect-to=/L2TPPOP/ \
    disabled=no ipsec-secret="/L2TPIPSEC/" comment=/L2TPPOP/ \
    use-ipsec=yes use-peer-dns=no user="/HOSTNAME/" password="/L2TPPWD/"
/interface lte apn
add apn=/APN/ name=/PROVIDER/ comment="MCCMNC=/MMCMNC/ MVNO=/MVNO/" use-peer-dns=no
/interface lte
set [ find ] allow-roaming=yes apn-profiles=/PROVIDER/ name=lte1 network-mode=lte \
    pin=/SIMPIN/
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/interface list
add name=WAN
/interface list member
add interface=l2tp-out1 list=WAN
add interface=lte1 list=WAN
/ip pool
add name=dhcpd ranges=10.1.10.10-10.1.10.254
/ip dhcp-server
add address-pool=dhcpd disabled=no interface=ether1 name=dhcpd src-address=\
    10.1.10.1
/ip neighbor discovery-settings
set discover-interface-list=!dynamic
/ip address
remove [find interface=ether1]
add address=10.1.10.1/24 interface=ether1 network=10.1.10.0
/ip cloud
set ddns-enabled=yes
/ip dhcp-server network
add address=10.1.10.0/24 dns-server=10.1.10.1 gateway=10.1.10.1
/ip dns
set allow-remote-requests=yes servers="8.8.8.8,8.8.4.4"
/ip firewall address-list
add address=cloud.mikrotik.com list=ddns
add address=cloud2.mikrotik.com list=ddns
/ip firewall mangle
add action=mark-connection chain=output dst-address-list=ddns new-connection-mark=ddns passthrough=yes
add action=mark-routing chain=output connection-mark=ddns new-routing-mark=ddns passthrough=no
/ip firewall nat
add action=masquerade chain=srcnat src-address=10.1.10.0/24
/ip route
add distance=1 gateway=lte1 routing-mark=ddns
add distance=3 dst-address=9.9.9.9/32 gateway=lte1
/ip route rule
add action=lookup-only-in-table routing-mark=ddns table=ddns
/system clock
set time-zone-autodetect=no time-zone-name=Europe/Madrid
/system identity
set name="/HOSTNAME/"
/system ntp client
set enabled=yes primary-ntp=185.232.69.65 secondary-ntp=192.36.143.130
/tool netwatch
add down-script="/int lte set [find] disabled=yes\r\
    \n/interface l2tp-client set [ find ] disabled=yes\r\
    \n/int lte set [find] disabled=no\r\
    \n\r\
    \n:local continue true\r\
    \n:local counter 0\r\
    \n:while (\$continue) do={:delay delay-time=240 ; :if ([/ping 9.9.9.9 count=1]=0) do={ :set \$counter (\$counter + 1);\
    \_:if (\$counter>5) do={:set counter 0 ; /sys reboot} else={/interface lte set [find] disabled=yes ; /int lte set [fin\
    d] disabled=no}} else={:set \$continue false ; :set \$counter 0}}\r\
    \n" host=9.9.9.9 interval=10s up-script=":delay delay-time=2\r\
    \n/ip cloud force-update\r\
    \n:delay delay-time=2\r\
    \n:local continue true\r\
    \n:while (\$continue) do={:if ([/ip cloud get public-address] = 188.213.5.220) do={/ip cloud force-update} else={:set \
    \$continue false}}\r\
    \n\r\
    \n:delay delay-time=10\r\
    \n/interface l2tp-client set [ find ] disabled=no\r\
    \n\r\
    \n\r\
    \n:set \$continue true\r\
    \n:delay delay-time=60\r\
    \n:while (\$continue) do={:delay delay-time=60 ; :if ([/interface l2tp-client get [find] running] = false) do={/ip cloud force-update ; :delay delay-time=\
    2 ; /interface l2tp-client set [find] disabled=yes ; :delay delay-time=2 ; /int l2tp-client set [find] disabled=no} else={:set \$continue false}}\r\
    \n"
/user
add group=full name=taglio
remove [find name=admin]
/user
set [find name=taglio] password="/USRPWD/"
/user ssh-keys import user=taglio public-key-file=id_rsa.pub
