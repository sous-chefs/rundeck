Description
===========
Cookbook installs Webtrends Device Data Updater component. 

Requirements
============
Recipes to be installed prior to this cookbook. Should be included as part of wt_devicedataupdater role
* `recipe[ms_dotnet4]`

Attributes
==========
* node['wt_devicedataupdater']['download_url'] - set to the deviceatlas URL do download devicedata from
* node['wt_devicedataupdater']['service_binary'] - name of Device Data Updater binary: DDU.exe
* node['wt_devicedataupdater']['install_dir'] - directory to install Device Data Updater


Data Bag Items
===============
* authorization data bag should have a data bag item for every environment Device Data Updater will be deployed to. It must contain the following values
	* `authorization['wt_common']['system_user']` - User that owns service
	* `authorization['wt_common']['system_pass']` - Password for system_user

Usage
=====

