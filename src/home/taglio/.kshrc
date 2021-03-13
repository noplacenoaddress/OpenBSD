. /etc/ksh.kshrc

alias ls="colorls -FG"
alias ports="netstat -an -f inet && netstat -an -f inet6"
alias rm="rm -PPPrf"
alias speedtest="wget -4 -O /dev/null --report-speed=bits"


PATH=$HOME/Bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:
PROMPT='$USER@$HOST:$PWD'"$PS1S"
PS1=$PROMPT
EDITOR=nano
TZ=Europe/Madrid
CVSROOT=anoncvs@anoncvs.spacehopper.org:/cvs
FTPMODE=passive
GPG_TTY=$(tty)
export PATH PROMPT PS1 EDITOR GPG_TTY TZ CVSROOT FTPMODE
