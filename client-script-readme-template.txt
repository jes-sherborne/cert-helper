The included script will create a Certificate Signing Request (CSR) for your personal certificate.

To use it, go to this directory and run the script

# cd /path/to/this/directory
# ./request.sh

It will create a file called ____fileName____.csr.pem. You need to send this file to your certificate administrator.

It also creates a file called ____fileName____.key.pem. This is the secret key for the certificate, and you should keep it safe.

When you get the certificate file back from your administrator, you should do the following:

1. Install the included root certificate (root-ca.cert.pem). Instructions at https://github.com/jes-sherborne/cert-helper#trusting-your-root-certificate

2. Create a PFX file to install your client certificate on your system as follows:

    2.1 Generate a secure password for your pfx file. Keep it in a safe place; you'll need it later.

    # openssl rand -base64 15

    2.2. Generate the pfx file itself, entering the password when prompted.

    # openssl pkcs12 -keypbe PBE-SHA1-3DES -certpbe PBE-SHA1-3DES -export -in "____fileName____.cert.pem" -inkey "____fileName____.key.pem" -certfile "ca.cert.pem" -out "____fileName____.pfx"  -name "____clientName____ - ____orgName____"

    2.3 Install the PFX file on your system: https://github.com/jes-sherborne/cert-helper#working-with-client-certificates
