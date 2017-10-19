# cert-helper

If you need to create X-509 certificates, you may find that it takes a lot of work to understand and configure OpenSSL. There are lots (and lots!) of different ways to use OpenSSL to manage a certificate authority, and while the flexibility is admirable, it's easy to get overwhelmed.

Cert-helper provides step-by-step guidance and automates typical tasks, so you will have a well-configured certificate authority that is suitable for a corporate intranet or development server.

## Getting started

Cert-helper is just a bash script, so it should work anywhere with a recent version of bash and OpenSSL. It has no other dependencies.

###1. Get the source files

```
$ git clone https://github.com/jes-sherborne/cert-helper.git
```

###2. Create a directory to hold your certificate files

Many of the files should be kept secret, so you should keep them somewhere safe. 

If you're just testing, it's fine to just create a directory on your local computer.

For more sensitive applications, a good compromise between convenience and security is to create an encrypted volume using something like [VeraCrypt](https://www.veracrypt.fr/en/Downloads.html). You should only mount this volume when you need to create new certificates.

###3. Create your certificate authority

Go to the cert-helper directory and type:

```
$ ./cert-helper.sh /path/to/cert/directory
```

You can use cert-helper to create files for local testing or production use.
 
__Tip:__ Be sure to save the generated passwords in a secure place like a password manager. You will need them to create new certificates and to install your client certificate.

###4. Configure extra security for production systems

If you are using these certificates in a production system, you should take additional steps to secure your root CA files. Because root CA files can create certificates that are trusted by anyone with the root certificate installed, you don't want them to get into the wrong hands.

Move the entire `root-ca` directory to its own encrypted storage. Ideally, you should keep this offline. You will only need to use it if you need to create another signing CA, so it will not inconvenience you to keep it offline.

## Creating additional certificates

After you have used cert-helper for the first time, you can continue to use it to create additional certificates as need. As before, just run:

```
$ ./cert-helper.sh /path/to/cert/directory
```

This time, you will get a menu of additional options which enable to create new client certificates, server, certificates, and signing CAs.

### Creating additional server certificates

You will need to supply the server's name. It's good idea to use the main DNS name or hostname that you will use for the server (although you can call the server whatever you want).

Thr critical part of the process is where you provide the DNS names and IP addresses. You should enter all the names and IP addresses that clients will use to connect to your server. For example, if they connect to it as _my-server.example.com_, you should include it. If clients will connect to the server directly by IP address, you should enter that as well.

You can include as many DNS names and IP addresses as you want. When you're done, just enter a blank line.

### Creating additional client certificates

All you need to do is supply the user's name and email address. cert-helper will create the private key and certificate. It will also create a password-protected PFX file that bundles the certificate and key together. You can use this to install the certificate and key on Mac or Windows. See below for instructions.

### Creating a new signing CA (Advanced)

This is an advanced topic, and if you don't know what this is, you almost certainly don't need it.

cert-helper uses a two-tiered system for creating certificates. First, it creates a root CA and a self-signed root certificate. The idea is that you keep the private key and password for the root CA tightly controlled.

It then creates a signing CA (sometimes called an Intermediate CA). This is what actually signs the certificates you use day-to-day.

If your organization has multiple distinct sets of clients and servers, you may want to manage their certificates independently. This can be especially useful if you have (for example) a development environment and a production environment. By creating multiple signing CAs, you can keep the certificates separated, so that a client cert that is signed by one CA cannot be used to connect to a server that is signed by a different CA.

In any case, to create a new signing CA, all you need to do is provide a name. From then on, whenever you create a client or server certificate, you will need to specify which signing CA to use.

## Creating a self-signed certificate for local development

If you are developing web software and you want to use https connections, it's handy to create a certificate just for your computer. cert-helper can do this for you automatically:

1. Create a directory to hold your local certificates `$ mkdir ~/local-ca`
2. Choose _Create files for local testing_
3. Go to the cert-helper directory and type `$ ./cert-helper.sh ~/local-ca`
4. For the organization, enter your name, your company name, or whatever suits you
5. Enter your name and email address at the prompts

You can use the server certificates to connect to your local machine using `https://127.0.0.1`, `https://localhost`, `https://your-server-name`. On a Mac, this will be something like `https://your-name-macbook-pro.local`.

If you install the root server as described below, you will see the reassuring green lock icon whenever you visit your local server in a web browser.

## Using your certificates

While your specific needs will determine how you use these certificates, here is some guidance that covers many common situations. While not specific to cert-helper, you may find it useful.

### Trusting your root certificate

You should install your root certificate on every computer that you want to automatically trust the certificates you create.

If you are using the certificates in production (for example on a corporate intranet), you will want to install the root certificate on every client computer in your team or organization.

If you are using the certificates for local testing, you should install the root certificate just on your own computer.

__To install a root certificate on a Mac:__

1. Open _Keychain Access_ (found in Applications » Utilities)
2. Select the _System_ keychain
3. Drag and drop `root-ca/certs/root-ca.cert.pem` into the list of certificates. It will show up with a red X indicating it is not trusted.
4. Double click the name of your certificate
5. Expand the _Trust_ section
6. Change _When using this certificate_ to _Always Trust_
7. Enter your system password as required
8. Your root certificate should show with a blue plus sign indicating that it is trusted.

### Working with client certificates

Some systems require client certificates. This provides a way for servers and clients to mutually authenticate each other, and it can provide a good alternative to usernames and passwords for systems that support it.

__To install a client certificate on a Mac:__

1. Open _Keychain Access_ (found in Applications » Utilities)
2. Select the _login_ keychain
3. Drag and drop `signing-ca-1/private/your-email-address.pfx` into the list.
4. Enter the generated password for the PFX file

### Working with server certificates

If you are running a web server, you will need to copy over all of the following:

* The server certificate (`signing-ca-1/certs/your-server-name.cert.pem`)
* The server private key (`signing-ca-1/private/your-server-name.key.pem`)
* The chain certificate (`signing-ca-1/certs/ca-chain.cert.pem`). This connects your server certificate to the root certificate, so that any client that trusts the root certificate will also trust your server certificate.

