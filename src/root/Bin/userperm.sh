#!/bin/ksh

if [[ $# -eq 0 ]];then
	print $0 "[userdir]"
	exit
fi

USER=$1

chown -R $USER:$USER /home/$USER
chmod -R o-rwx /home/$USER
