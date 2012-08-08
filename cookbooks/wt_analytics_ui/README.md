Description
===========
This cookbook installs and configures Webtrends Analytics UI.

Requirements
============
The following recipes must be included in the wt_analytics_ui role prior to running this cookbooks default recipe
* `recipe[vc2010]`
* `recipe[ms_dotnet4]`
* `recipe[ms_messagequeue]`
* `recipe[wt_base::msdtc]`
* `role[iis]`
* `recipe[iis::mod_compress_dynamic]`
* `recipe[iis::mod_aspnet]`

Attributes
==========
* `node['cassandra']['cassandra_host']` - Load balanced address to cassandra
* `node['cassandra']['cassandra_meta_column']` - Meta column for cassandra to use
* `node['cassandra']['cassandra_report_column']` - Report column for cassandra to use
* `node['cassandra']['cassandra_thrift_port']` - Thrift port for cassandra to use
* `node['hbase']['location']` - Load balanced address of Hbase nodes
* `node['hbase']['thrift_port']` - Thrift port used by Hbase
* `node['hbase']['data_center_id']` - Data Center ID
* `node['hbase']['pod_id']` - Pod ID
* `node['memcached']['cache_hosts']` - An array of all memcache boxes
* `node['wt_analytics_ui']['app_pool_private_memory']` - Amount of memory to give app pool
* `node['wt_analytics_ui']['bba_domain']` - Blackberry domain(ie. blackberry.webtrends.com)
* `node['wt_analytics_ui']['cache_region']` - Region for cache configuration
* `node['wt_analytics_ui']['custom_errors']` - custom IIS errors
* `node['wt_analytics_ui']['download_url']` - Http location of where to retrieve the build that should be deployed
* `node['wt_analytics_ui']['fb_app_clientid']` - Client ID for facebook app
* `node['wt_analytics_ui']['fb_app_clientsecret']` - Secret passphrase for facebook app
* `node['wt_analytics_ui']['help_link']` - Help link
* `node['wt_analytics_ui']['hmap_url']` - Heatmaps URL
* `node['wt_analytics_ui']['proxy_address']` - Address of proxy
* `node['wt_analytics_ui']['reinvigorate_tracking_code']` - Reinvigorate tracking code
* `node['wt_common']['install_dir_windows']` - Base location for all windows products to be installed(ie. "D:\\wrs")
* `node['wt_dx']['rest_base_uri']` - URL to DX box to make REST calls to(ie. https://ws.webtrends.com/v3)
* `node['wt_masterdb']['master_host']` - Host name of masterdb
* `node['wt_messaging_monitoring']['monitor_service_addr'] - 
* `node['wt_search']['search_hostname']` - Load balanced address of search boxes

Data Bag Items
===============
* authorization data bag should have a data bag item for every environment Analytics will be deployed to. It must contain the following values
	* `authorization['wt_common']['ui_user']` - User that owns the app pool and site in IIS
	* `authorization['wt_common']['ui_pass']` - Password for ui_user

Usage
=====

