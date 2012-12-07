## 1.1.6
  * renamed system database attributes
## 1.1.5
  * Changing RSA key to be added by UI user.
## 1.1.4
  * Fixing user 
## 1.1.3
  * Added .html to allowed extension list.
## 1.1.2
  * Fixed the template for the rsa key
## 1.1.1
  * Updated the data bag used for rsa keys
## 1.1.0
  * Fixed rsa key name.
## 1.0.17
  * Added process to add user permissions to machinekey folder before adding key
## 1.0.16
  * Adding ui user to run as
	* Fixing d line
## 1.0.15
  * Adding - in command
## 1.0.14
  * Added delete back in
	* Fixed templates
## 1.0.13
  * Commented out file delete
## 1.0.12
  * Hard coded path to aspnet_regiis
## 1.0.11
  * Moved rsa key from the authorization databag
	* Changed path for calling asp command
## 1.0.10
	* Added rsa file data to template/databag and updated recipe to consume
## 1.0.9
	* Removed Chomp
## 1.0.8
	* Fixed template comment
## 1.0.7
	* Added chomp to deploy build check	
## 1.0.6
	* Added .eql to deploy build check
## 1.0.5
	* Removed webpi > in metadata
## 1.0.4
	* Updated Castle.Core binding redirect
## 1.0.3
	* Added comment line to template
## 1.0.2
	* Removed default download url. Cleaned up default recipe to improve readability
## 1.0.1
	* Merge 10.5 hotfixe to master.
## 0.0.31
	Merge in HBase parameter moves.
## 0.0.30
	Adding missing parameters
## 1.0.0   
	* Incremented version to allow room for hotfixes
## 0.0.29
	Changed hbase settings to use wt_common version of pod_id and moved fb_data_center_id under wt_analtics_ui
## 0.0.28
	Hard code the thrift port for hbase since it's not actually tunable.

## 0.0.27
	Added YouTube settings

## 0.0.26
	Merged IIS config into default.rb

## 0.0.25
	Added general IIS configuration

## 0.0.24
	Changed monitor_service_addr to monitor_hostname
	Changed rest_uri to be under wt_dx rather then wt_analytics_ui
	Removed rest_uri from default attributes

## 0.0.23
	Cookbook renamed to wt_analytics_ui
	Share wrs folder
	Added log4net.config template

## 0.0.22
	Added UI user to MachineKeys folder
	Added UI user to Performance Monitor Users

## 0.0.21
	Added PatentsLink configuration item to appSettings in web.config template
	Added many new attributes
	Added mapping.xml.erb and webtrends-brand.xml.erb
	Removed install_logdir creation

## 0.0.18
	Added hbase values to web.config template
