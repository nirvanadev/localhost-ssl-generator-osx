#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;93m'
NC='\033[0m'

read -p 'Domain: ' domain


openssl req \
    -newkey rsa:2048 \
    -x509 \
    -nodes \
    -keyout "${domain}".key \
    -new \
    -out "${domain}".crt \
    -subj /CN="${domain}" \
	-addext "subjectAltName = DNS:${domain}" \
    -sha256 \
    -days 3650

mkdir -p ./certs

mv *.crt ./certs/
mv *.key ./certs/

sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" "./certs/${domain}.crt"

echo -e ${GREEN}"Cert created and trusted! ${NC}"
