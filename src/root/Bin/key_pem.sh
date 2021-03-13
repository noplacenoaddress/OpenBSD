#!/bin/ksh

openssl rsa -in $1 -text > $1.pem
