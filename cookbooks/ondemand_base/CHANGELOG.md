## Future

* Set chef-client to run under runit
* Include the delete-validation recipe with chef-client to delete the validation.pem file
* Include dell-tools on Dell systems
* Include hp-tools on HP systems

## 10.4:
 * Install collectd with the Webtrends base plugins
 * Disable fprintd (finger print authentication) on CentOS boxes.  It crashes every time a user runs sudo
 * Better error logs when a recipe run on the wrong platform
 * Include the apt repo after webtrends repo is added so the cache gets cleared correctly on Ubuntu
 * Remove the hack to install likewise-open package in the Ubuntu recipe
 
## 10.3:
* Installs vmware-tools
* Installs and configures NRPE including configuration of nrpe.cfg and installation of plugins
* Installs likewise the proper way avoiding some failure scenarios, which required systems be rebuilt
* Includes a new platform recipe case statement that allows for a simpler ondemand_server role configuration
* References ondemand_base for attributes and not ondemand_server, which was against best practices
* Properly sets file modes to match best practices
* Prevents the Windows recipe from running on non-Windows systems, which resulted in a chef-client crash
* Saves the node back to the Chef server to prevent run lists from being wiped if a run fails during provisioning
* Sets high performance Power configs on Windows systems
* Disables hibernation on Windows systems  