Description
===========
Cookbook installs Webtrends Data Deleter Service.

Requirements
============
Recipes to be installed prior to this cookbook. Should be included as part of wt_data_deleter role
* `recipe[ms_dotnet4]`
* `recipe[ms_messagequeue]`
* `recipe[wt_base::msdtc]`

Attributes
==========
* `node['cassandra']['cassandra_host']` - Load balanced address to cassandra
* `node['cassandra']['cassandra_meta_column']` - Meta column for cassandra to use
* `node['cassandra']['cassandra_report_column']` - Report column for cassandra to use
* `node['cassandra']['cassandra_thrift_port']` - Thrift port for cassandra to use
* `node['wt_common']['install_dir_windows']` - Base location for all windows products to be installed(ie. "D:\\wrs")
* `node['wt_common']['wrsmodify_group']` - Windows AD group that should have modify access to the install dir
* `node['wt_common']['wrsread_group']` - Windows AD group that should have read access to the install dir
* `node['wt_data_deleter']['download_url']` - Http path to where the zip file to deploy is located
* `node['wt_masterdb']['host']` - Host name of masterdb
* `node['hbase']['location']` - Hostname for hbase
* `node['wt_analytics_ui']['fb_data_center_id']` - Data center id for hbase
* `node['wt_common']['pod_id']` - PodId for hbase


Data Bag Items
===============
* authorization data bag should have a data bag item for every environment Search will be deployed to. It must contain the following values
	* `authorization['wt_common']['system_user']` - User that owns service
	* `authorization['wt_common']['system_pass']` - Password for system_user

Usage
=====
