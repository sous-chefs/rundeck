Description
===========

Installs the Webtrends CAM service and its plugins on Windows servers
 

Requirements
============
Recipes to be installed prior to this cookbook. Should be included as part of the wt_cam role.
* recipe[ms_dotnet35]
* recipe[ms_dotnet4]
* role[iis]
* recipe[iis::mod_mvc3]

Attributes
==========
* node['wt_common']['install_dir_windows'] - Windows install directory
* node['wt_common']['install_log_dir_windows'] - Directory for windows install logs
* node['wt_common']['ldap_host'] - Name of ldap host machine
* node['wt_common']['ldap_port'] - Port for ldap access
* node['wt_common']['smtp_server'] - Address of the server cam uses to send user emails
* node['wt_streaming_viz']['streams_ui_url'] - Url to the streams UI, included in the user emails
* node['wt_streaming_viz']['sms_url'] - Url to the streaming management service

* node['wt_cam']['app_pool'] - Name to assign the app pool for the iis app that hosts the service
* node['wt_cam']['cam'] ['download_url'] - Url of the artifacts needed to deploy the cam service
* node['wt_cam']['cam_plugins']['download_url'] - Url of the artifacts needed to deploy the cam plugins
* node['wt_cam']['db_server'] - Name of the server that hosts the cam database
* node['wt_cam']['db_name'] - Name of the sql database for cam
* node['wt_cam']['tokenExpirationMinutes'] - Length of time a token should remain valid in minutes
* node['wt_cam']['port'] - Http port to install the iis app that hosts the service
* node['wt_cam']['log_level'] - Granularity setting for log4net entries

Data Bag Items
===============
* authorization['wt_common']['ui_user'] - User under which the service will run
* authorization['wt_common']['ldap_user'] - LDAP Admin user identity
* authorization['wt_common']['ldap_password'] - LDAP Admin user password

Usage
=====
