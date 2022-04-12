#!/bin/ksh

OLDIP=$(/usr/bin/dig A "${1}")
while true; do
    [[ $(/usr/bin/dig A "${1}" +short) != "${OLDIP}" ]] && (
        /usr/sbin/ikectl reload
        exit
        )
done
