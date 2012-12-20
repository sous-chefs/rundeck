Description
===========
 
Installs the Webtrends ActionCenter IIS WebAPI service 
 
 
Requirements
============
Recipes to be installed prior to this cookbook. Should be included as part of the wt_actioncenter role.
* recipe[ms_dotnet4]
* recipe[ms_messagequeue]
* role[iis]
* recipe[iis::mod_mvc4]
 
Attributes
==========
* node['wt_common']['install_dir_windows'] - Windows install directory
* node['wt_common']['install_log_dir_windows'] - Directory for windows install logs

* node['wt_masterdb']['host'] - Host name of masterdb
* node['wt_actioncenter']['app_pool'] - Name to assign the app pool for the iis app that hosts the service
* node['wt_actioncenter']['download_url'] - Url of the artifacts needed to deploy the cam service
* node['wt_actioncenter']['port'] - Http port to install the iis app that hosts the service
* node['wt_actioncenter']['log_level'] - Granularity setting for log4net entries
 
Data Bag Items
===============
* authorization['wt_common']['ui_user'] - User under which the service will run
 
Usage
=====
