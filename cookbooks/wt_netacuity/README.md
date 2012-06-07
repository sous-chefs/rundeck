= DESCRIPTION:
Installs NetAcuity Server preloaded with a Webtrends license key (thus the wt_netacuity name)

= REQUIREMENTS:
* java
* runit

= ATTRIBUTES:
* 'version': The version to install
* 'download_url': The URL to download the tgz of the NetAcuity service
* 'install_dir': The directory to install NetAcuity to (without a trailing slash)
* 'proxy_port': The port of the proxy server that NetAcuity will connect to 
* 'proxy_address': The address of the proxy server that NetAcuity will connect to

= USAGE: