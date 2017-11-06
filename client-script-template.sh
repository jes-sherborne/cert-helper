#!/usr/bin/env bash

echo "*****************************************************************************"
echo "Generating a private key and certificate signing request (CSR)..."
echo "*****************************************************************************"
echo ""

openssl genrsa -out "____clientFileName____.key.pem" 2048
if [ ! $? -eq 0 ]; then
  echo "Encountered error and could not continue"
  exit 1
fi
chmod 400 "____clientFileName____.key.pem"

openssl req -config "request.conf" -key "____clientFileName____.key.pem" -new -sha256 -out "____clientFileName____.csr.pem"
if [ ! $? -eq 0 ]; then
  echo "Encountered error and could not continue"
  exit 1
fi
chmod 444 "____clientFileName____.csr.pem"

echo "*****************************************************************************"
echo "Created your csr file (____clientFileName____.csr.pem). Send it to your domain administrator."
echo "Also created your private key file (____clientFileName____.key.pem). This is a secret, so keep it safe."
echo "See README.txt for additional details."
echo "*****************************************************************************"
