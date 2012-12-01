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
* `node['wt_analytics_ui']['ios_public_key'] - Public key for iOS
* `node['wt_analytics_ui']['facebook_public_key'] - Public key for Facebook
* `node['wt_analytics_ui']['android_public_key'] - Public key for Android
* `node['wt_analytics_ui']['youtube_public_key'] - Public key for YouTube
* `node['wt_analytics_ui']['twitter_public_key'] - Public key for Twitter
* `node['wt_analytics_ui']['tagbuilder_download_url'] - Download URL for TagBuilder 
* `node['wt_analytics_ui']['tagbuilder_url_template'] - Template URL for Tag Builder
* `node['wt_analytics_ui']['tagbuilder_domain'] - TagBuilder domain
* `node['wt_analytics_ui']['tagbuilder_domainmobile'] - TagBuilder Mobile Domain
* `node['wt_analytics_ui']['remote_access'] - 0 to disable remote access, 1 to enable
* `node['wt_common']['install_dir_windows']` - Base location for all windows products to be installed(ie. "D:\\wrs")
* `node['wt_common']['wrsmodify_group']` - Windows AD group that should have modify access to the install dir
* `node['wt_common']['wrsread_group']` - Windows AD group that should have read access to the install dir
* `node['wt_dx']['rest_base_uri']` - URL to DX box to make REST calls to(ie. https://ws.webtrends.com/v3)
* `node['wt_masterdb']['host']` - Host name of masterdb
* `node['wt_messaging_monitoring']['monitor_hostname'] - 
* `node['wt_search']['search_hostname']` - Load balanced address of search boxes

Data Bag Items
===============
* authorization data bag should have a data bag item for every environment Analytics will be deployed to. It must contain the following values
	* `authorization['wt_common']['ui_user']` - User that owns the app pool and site in IIS
	* `authorization['wt_common']['ui_pass']` - Password for ui_user

Usage
=====

