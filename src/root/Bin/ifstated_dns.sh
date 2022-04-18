#!/bin/ksh


OLDIP=$(/usr/bin/dig A "${1}" +short)

[[ $(/usr/bin/dig A "${1}" +short) != "${OLDIP}" ]] && (
    return 0
) || return 1
