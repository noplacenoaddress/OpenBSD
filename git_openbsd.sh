#!/bin/bash

DATE=$(date +%d%m%Y)
DATE_RELEASE=$(date +"%d/%m/%Y %H:%m:%S")
<<<<<<< Updated upstream
HOMEWRK="/home/riccardo/Work/telecom.lobby"
=======
<<<<<<< HEAD
HOMEWRK="/home/taglio/Work/telecom.lobby"
=======
HOMEWRK="/home/riccardo/Work/telecom.lobby"
>>>>>>> master
>>>>>>> Stashed changes
REPO="/OpenBSD"
RELEASE="/OpenBSD$DATE.tar"

echo "creating tar release"
rm -rf "$HOMEWRK$RELEASE"
tar --exclude="$HOMEWRK$REPO/.git/*" -cvf "$HOMEWRK$RELEASE" "$HOMEWRK$REPO"

echo "git add, commit, sign and push"
cd "$HOMEWRK$REPO"
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
