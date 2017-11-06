#!/usr/bin/env bash

echo "*****************************************************************************"
echo "Generating a private key and certificate signing request (CSR)..."
echo "*****************************************************************************"
echo ""

openssl genrsa -out "____fileName____.key.pem" 2048
if [ ! $? -eq 0 ]; then
  echo "Encountered error and could not continue"
  exit 1
fi
chmod 400 "____fileName____.key.pem"

openssl req -config "request.conf" -key "____fileName____.key.pem" -new -sha256 -out "____fileName____.csr.pem"
if [ ! $? -eq 0 ]; then
  echo "Encountered error and could not continue"
  exit 1
fi
chmod 444 "____fileName____.csr.pem"

echo "*****************************************************************************"
echo "Created your csr file (____fileName____.csr.pem). Send it to your domain administrator."
echo "Also created your private key file (____fileName____.key.pem). This is a secret, so keep it safe."
echo "See README.txt for additional details."
echo "*****************************************************************************"
