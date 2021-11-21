/ip firewall mangle
add action=mark-connection chain=prerouting connection-mark=no-mark in-interface=/GRE/ new-connection-mark=/POPLOCALHOSTNAME/ passthrough=yes
add action=mark-routing chain=prerouting connection-mark=/POPLOCALHOSTNAME/ new-routing-mark=/POPLOCALHOSTNAME/ passthrough=yes
/ip route rule
add routing-mark=/POPLOCALHOSTNAME/ table=/POPLOCALHOSTNAME/
/ip route
add distance=1 gateway=/GRE/ routing-mark=/POPLOCALHOSTNAME/ comment=/POPLOCALHOSTNAME/
