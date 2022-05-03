# $OpenBSD: dot.profile,v 1.5 2018/02/02 02:29:54 yasuoka Exp $
#
# sh/ksh initialization
<<<<<<< Updated upstream
dmesg | head -n 4
uptime
#ospfctl sh nei
/usr/games/fortune -a 
=======
<<<<<<< HEAD
cat <<EOF
    ____                 __     ____       __                __
   / __ \___  ________  / /_   / __ \___  / /_  ____  ____  / /_
  / /_/ / _ \/ ___/ _ \/ __/  / /_/ / _ \/ __ \/ __ \/ __ \/ __/
 / _, _/  __(__  )  __/ /_   / _, _/  __/ /_/ / /_/ / /_/ / /_
/_/ |_|\___/____/\___/\__/  /_/ |_|\___/_.___/\____/\____/\__/

EOF

dmesg | head -n 4
uptime
ospfctl sh nei
/usr/games/fortune -a
=======
dmesg | head -n 4
uptime
#ospfctl sh nei
/usr/games/fortune -a 
>>>>>>> master
>>>>>>> Stashed changes
export ENV=$HOME/.kshrc
