/ip firewall mangle add action=mark-connection chain=input connection-mark=no-mark dst-address=/ROUTERID/ in-interface=/GRE/ new-connection-mark=/POPLOCALHOSTNAME/ passthrough=yes
/ip firewall mangle add action=mark-routing chain=output connection-mark=/POPLOCALHOSTNAME/ new-routing-mark=/POPLOCALHOSTNAME/ out-interface=!/GRE/ passthrough=yes src-address=/ROUTERID/
/ip route rule add routing-mark=/POPLOCALHOSTNAME/ table=/POPLOCALHOSTNAME/ action=lookup-only-in-table
/ip route add distance=1 gateway=/GRE/ routing-mark=/POPLOCALHOSTNAME/ comment="from /POPLOCALHOSTNAME/ to /ROUTERID/"
