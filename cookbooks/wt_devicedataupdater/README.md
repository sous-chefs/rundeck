Description
===========
Installs the configures the Webtrends Device Data Updater executeable

Requirements
============
Windows cookbook

Attributes
==========
node['wt_devicedataupdater']['download_url'] - full url to DeviceDataUpdater.zip
node['wt_devicedataupdater']['install_dir'] - subfolder containing runtime files
node['wt_devicedataupdater']['log_dir'] - subfolder containing logs
node['wt_devicedataupdater']['service_binary'] - executable name (DDU.exe)
node['wt_common']['config_share'] - system master's primary config data location
node['wt_common']['install_dir_windows'] - parent install folder


Data Bag Items
===============

Usage
=====
