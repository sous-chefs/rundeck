# rundeck_apache #

Use the **apache** resource to install and configure the Apache reverse proxy.

## Syntax ##

The full syntax for all of the properties available to the **apache** resource is:

----

```ruby
rundeck_apache 'apache' do
  use_ssl               [true, false] # Whether to use SSL
  cert_location         String # Folder to store ssl files and keys
  cert_name             String # Name of the cert file without extension.
  cert_contents         String # Certificate
  key_contents          String # Private key
  ca_cert_name          String # Name of the CA cert file without extension.
  hostname              String # Hostname
  email                 String # Email address for Apache site.
  allow_local_https     [true, false]
  webcontext            String # The URI portion of the rundeck server, default '/', you can set it to '/rundeck' if your webserver is handling other tasks besides rundeck.
  port # Port
end
```

## Actions ##

`:install`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Install the Apache service. This is the only, and default, action.

## Examples ##

### Install the Rundeck service with defaults ###

```ruby
rundeck_apache 'Apache' do
  action :install
end
```