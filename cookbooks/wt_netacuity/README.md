= DESCRIPTION:
Installs NetAcuity Server preloaded with a Webtrends license key (thus the wt_netacuity name)

= REQUIREMENTS:
* java
* wt_base

= ATTRIBUTES:
* 'version': The version to install
* 'download_url': The URL to download the tgz of the NetAcuity service
* 'install_dir': The directory to install NetAcuity to (without a trailing slash)
* 'proxy_port': The port of the proxy server that NetAcuity will connect to 
* 'proxy_address': The address of the proxy server that NetAcuity will connect to

= USAGE:
Add wt_netacuity role to a node to apply this cookbook.  Make sure you specify at least
the following attributes: version and download_url.  You will also need a wt_netacuity section
in the authorization data bag for your environment that includes "admin_password".  You
can use the default staging password hashed, which is SHvWHezZSc7