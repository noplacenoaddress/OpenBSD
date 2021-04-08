#!/bin/bash

DATE=$(date +%d%m%Y)
DATE_RELEASE=$(date +"%d/%m/%Y %H:%m:%S")

echo "updating date in scripts"
sed '3 s/.*/#	Telecomlobby: setup_node,v 0.1 `echo $DATE_RELEASE` taglio $/' /home/riccardo/Work/telecom.lobby/OpenBSD/setup_node

echo "creating tar release"
rm -rf /home/riccardo/Work/telecom.lobby/OpenBSD/OpenBSD.tar
tar --exclude='/home/riccardo/Work/telecom.lobby/.git/' -cvf /home/riccardo/Work/telecom.lobby/OpenBSD.tar /home/riccardo/Work/telecom.lobby/OpenBSD/
mv /home/riccardo/Work/telecom.lobby/OpenBSD.tar /home/riccardo/Work/telecom.lobby/OpenBSD/
echo "git add, commit, sign and push"
cd /home/riccardo/Work/telecom.lobby/OpenBSD/
echo "check branch"
BRANCHCTRL=$(git branch | grep $DATE)
if [ -z "${BRANCHCTRL}" ]
then
	git checkout -b taglio-$DATE
	git push --set-upstream origin taglio-$DATE
fi	
git add .
git commit -S
git push --force
