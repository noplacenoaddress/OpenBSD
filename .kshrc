. /etc/ksh.kshrc

alias ls="colorls -FG"
alias ports="netstat -an -f inet && netstat -an -f inet6"

PATH=$HOME/Bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin
PROMPT='$USER@$HOST:$PWD'"$PS1S"
PS1=$PROMPT
EDITOR=nano
export PATH PROMPT PS1 EDITOR
