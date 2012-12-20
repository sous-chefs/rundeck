= DESCRIPTION:
Installs Webtrends Heatmaps Log Converter

= REQUIREMENTS:
* java

The authorization databag for your environment must include the public/ private key for the Hadoop user on the
Hadoop cluster you will be interacting with.  This is used to SCP the completed files to the appropriate data 
nodes.  This key should be converted from the original to replace newlines with "/n" and form a single continuous 
string.

Example:
  "hadoop": {
    "public_key": "ssh-rsa PUB_KEY_WOULD_BE HERE hostedops@webtrends.com",
    "private_key": "-----BEGIN RSA PRIVATE KEY-----/n PRIVATE_KEY_WOULD_BE_HERE /n-----END RSA PRIVATE KEY-----"
  },

= ATTRIBUTES:

= USAGE: