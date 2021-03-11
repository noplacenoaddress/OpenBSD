#!/bin/ksh

function main {
	echo "changing installurl"
	echo "https://cdn.openbsd.org/pub/OpenBSD" > /etc/installurl
	echo "adding packages"
	pkg_add colorls nano wget
}
main
