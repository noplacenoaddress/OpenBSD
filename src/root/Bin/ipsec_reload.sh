#!/bin/ksh

ipsecctl -F
rcctl restart iked
