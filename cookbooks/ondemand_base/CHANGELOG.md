## Future

 * Set chef-client to run under runit
 * Include the delete-validation recipe with chef-client to delete the validation.pem file

## 1.7.3
 * Take out the creation of the webtrends user on centos.  This is causing odd failures and isn't used (yet)
 * Removed windows rubyzip 0.9.5 install
 
## 1.7.2
 * Add libxtst6 and libxtst-dev packages for Java troubleshooting on Ubuntu systems

## 1.7.1
 * Add MegaRAID MegaCLI on Dell boxes with the MegaRAID controller and sas2ircu to Dell boxes with the Perc H200 controller
 * Make sure to create the alternative non-root user's home dir

## 1.7
 * Include dell-tools on Dell systems

## 1.6
 * Installs hp-tools (System Management Homepage) on HP hardware boxes running CentOS/RH
 
## 1.5
 * Give Dev Users sudo access if the node has the ea_server role
 * Add code to join the domain to the Windows cookbook
 * Setup our repo and apt first on Ubuntu so we have an updated package list before installing packages
 * skip running nagios::client recipe if node['nagios']['client']['skip_install'] is set to true
 * Add a webtrends user/group on Ubuntu/Centos with a uid/guid of 2002 for our product to run under

## 1.4:
 * Install collectd with the Webtrends base plugins
 * Disable fprintd (finger print authentication) on CentOS boxes.  It crashes every time a user runs sudo
 * Better error logs when a recipe run on the wrong platform
 * Include the apt repo after webtrends repo is added so the cache gets cleared correctly on Ubuntu
 * Remove the hack to install likewise-open package in the Ubuntu recipe
 
## 1.3:
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
