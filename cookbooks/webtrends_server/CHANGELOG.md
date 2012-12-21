## 1.8.10
 * Switch to md for the readme
 * Add an optional value of arch for the apt repo LWRP now that apt 1.7.0 cookbook supports this
 * Update the updatechef cookbook to update to the new current version of 10.16.2

## 1.8.9
 * Change the detection of the _default environment so that it fails the run, but doesn't kill the running daemon
 * Add name metadata

## 1.8.8
 * Added step to manually install rubyzip

## 1.8.7
 * Remove ability to disable NRPE install on CentOS.
 * Update the updater version to 10.14.4

## 1.8.6
 * Removed the force install of rubyzip

## 1.8.5
 * Fixed ordering of correctly setting gem repo

## 1.8.4
 * Update the updatechef cookbook to update to the new current version of 10.14.2
 * Add supports for ubuntu/centos/windows in the metadata
 * Roll the installation of screen into the "useful tools" installation section

## 1.8.3
 * Adding screen to ubuntu and centos

## 1.8.2
 * Address foodcritic warnings by using strings instead of symbols and including apt in the metadata

## 1.8.1
 * Added resource to add gem repo for windows

## 1.8.0
 * Rename ondemand_base to webtrends_server.  Two fold:  This cookbook will be used for Optimize as well going forward and it should match the role name

## 1.7.13
 * Added gem_repo creation for windows

## 1.7.12
 * Added 'webtrends' user to centos

## 1.7.11
 * Fixing path of log

## 1.7.10
 * Adding -L to create log and redirecting to nul

## 1.7.9
 * Changing redirect from nul to log

## 1.7.8
 * Removed logging entirely to get the damn thing to work

## 1.7.7
 * Removed type statement to the end of deploy.bat to display log

## 1.7.6
 * Added type statement to the end of deploy.bat to display log

## 1.7.5
 * Modified the deploy.bat to redirect to nil

## 1.7.4
 * Modified the deploy.bat to test launching builds remotely.

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
