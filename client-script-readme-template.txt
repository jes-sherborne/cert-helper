The included script will create a Certificate Signing Request (CSR) for your personal certificate.

To use it, go to this directory and run the script

# cd /path/to/this/directory
# ./request.sh

It will create a file called ____clientFileName____.csr.pem. You need to send this file to your certificate administrator.

It also creates a file called ____clientFileName____.key.pem. This is the secret key for certificate, and you should keep it safe.

When you get the certificate file back from your administrator, you can create a PFX file to install it into your system. Here's how:

1. Generate a secure password for your pfx file.

  # openssl rand -base64 15

2. Generate the pfx file itself, entering the password when prompted.

  # openssl pkcs12 -keypbe PBE-SHA1-3DES -certpbe PBE-SHA1-3DES -export -in "____clientFileName____.cert.pem" -inkey "____clientFileName____.key.pem" -certfile "ca.cert.pem" -out "____clientFileName____.pfx"  -name "____clientName____ - ____orgName____"

In the meantime, you can add the root-ca certificate to your system if you haven't already.
