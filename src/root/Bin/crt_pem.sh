#!/bin/ksh

openssl x509 -inform DER -outform PEM -in $1 -out $1.pem
