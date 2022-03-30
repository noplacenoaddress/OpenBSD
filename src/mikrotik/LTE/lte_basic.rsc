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
add action=mark-routing chain=output dst-address-list=ddns new-routing-mark=\
    ddns passthrough=yes
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
add down-script=\
    "/int lte set [find] disabled=yes\r\
    \n/int lte set [find] disable=no\r\
    \n" host=9.9.9.9 interval=3m up-script="/ip cloud force-update\r\
    \n:delay delay-time=10\r\
    \n/interface l2tp-client set [ find ] disabled=yes\r\
    \n/interface l2tp-client set [ find ] disabled=no"
/user
add group=full name=taglio
remove [find name=admin]
/user
set [find name=taglio] password="/USRPWD/"
/user ssh-keys import user=taglio public-key-file=id_rsa.pub
