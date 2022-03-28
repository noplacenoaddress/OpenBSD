/interface l2tp-client
add add-default-route=yes allow-fast-path=yes connect-to=/L2TPPOP/ \
    disabled=no ipsec-secret="/L2TPIPSEC/" \
    use-ipsec=yes use-peer-dns=yes user="/HOSTNAME/" password="/L2TPPWD/"
/interface lte apn
add apn=/APN/ name=/PROVIDER/ comment="MCCMNC=/MMCMNC/ MVNO=/MVNO/"
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
set allow-remote-requests=yes
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
/ip route rule
add action=lookup-only-in-table routing-mark=ddns table=ddns
/system clock
set time-zone-autodetect=no time-zone-name=Europe/Madrid
/system identity
set name="/HOSTNAME/"
/system ntp client
set enabled=yes primary-ntp=185.232.69.65 secondary-ntp=192.36.143.130
/user
add group=full name=taglio
remove [find name=admin]
/user
set [find name=taglio] password="/USRPWD/"
