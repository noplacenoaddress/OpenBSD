/file remove [find type=".crt file"]
/file remove [find type="ssh key"]
/file remove [find type=".p12 file"]
/ip ipsec proposal remove [find where name!=default]
/ip ipsec policy remove [find where group!=default]
/ip ipsec identity remove [find]
/ip ipsec policy group remove [find where name!=default]
/ip ipsec peer remove [find]
/ip ipsec profile remove [find where name!=default]
/certificate remove [find]
/file remove [find type="script"]
/ip address remove [find interface!=ether1]
/interface gre remove [find]
/routing filter remove [find]
