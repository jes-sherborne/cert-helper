The included script will create a Certificate Signing Request (CSR) for your server.

To use it, go to this directory and run the script

# cd /path/to/this/directory
# ./request.sh

It will create a file called ____fileName____.csr.pem. You need to send this file to your certificate administrator.

It also creates a file called ____fileName____.key.pem. This is the secret key for the certificate, and you should keep it safe.
