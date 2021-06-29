/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set system task-scheduler task ES/PUBLICHOSTNAME/
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set system task-scheduler task ES/PUBLICHOSTNAME/ executable path /config/scripts/ES/PUBLICHOSTNAME/_netwatch.sh
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set system task-scheduler task ES/PUBLICHOSTNAME/ interval 1m
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper commit
/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper save
