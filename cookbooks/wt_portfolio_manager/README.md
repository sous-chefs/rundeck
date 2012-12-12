Description
===========
Installs the Webtrends Portfolio Manager site on Windows servers

Requirements
============
Recipes to be installed prior to running this cookbook. Should be included as part of the wt_PortfolioManager role.

* webpi, windows, 
* recipe[ms_dotnet4]
* role[iis]
* recipe[iis::mod_auth_windows]

Attributes
==========
* node['wt_common']['install_dir_windows'] - Windows install directory
* node['wt_common']['install_log_dir_windows'] - Directory for windows install logs
* node['wt_common']['http_proxy_url'] - Location of proxy, if enabled.
* node['wt_cam']['cam_service_url'] - Base URL to access CAM endpoints in the environment. 
* node['wt_portfolio_manager']['app_pool'] - Name of IIS application pool for Portfolio Manager.
* node['domain'] - Domain of environment (staging.dmz, netiqdmz, etc.)
* node['wt_portfolio_manager']['portmgr_group_admin'] - Comma delimited list of ActiveDirectory security groups that gates access to full administrative capabilities of Portfolio Manager.
* node['wt_portfolio_manager']['portmgr_group_user'] - Comma delimited list of ActiveDirectory security groups that gates access to common user level capabilities of Portfolio Manager.
* node['wt_portfolio_manager']['portmgr_injected_user'] - Email address or distribution list of user/group to add upon creation of Portfolio Accounts.
* node['wt_portfolio_manager']['port'] - Http port to expose the Portfolio Manager website.
* node['wt_portfolio_manager']['log_level'] - Granularity setting for log4net entries (INFO, WARN, ERROR, etc).
* node['wt_portfolio_manager']['elmah_remote_access'] - Toggle to allow/disallow elmah from remote clients (yes, no).
* node['wt_portfolio_manager']['custom_errors'] - Toggle to enable viewing custom errors from clients (On, Off).
* node['wt_portfolio_manager']['proxy_enabled'] - Toggle to enable or disable proxy for initiating external connections when behind firewall (true, false).
* node['wt_portfolio_manager']['cam_service_url_base'] - Root path portion for accessing CAM endpoints in the environment, if any (e.g., /v1).
* node['wt_aps']['service_url'] - Base URL to access APS endpoints in the environment.
* node['wt_aps']['aps_url_base'] - Root path portion for accessing APS endpoints in the environment (/aps/ vs /accountprovisioning/, etc).
* node['wt_streamingconfigservice']['config_service_url'] - Base URL to access the Config Service in the environment.
* node['wt_management_console']['service_url'] - Base URL to access the OnDemand Management Console in the environment.
 
Data Bag Items
===============
* authorization['wt_common']['ui_user'] - User under which the service will run
* authorization['wt_common']['ui_pass'] - Password for ui_user.

Usage
=====
Installation:
   set deploy_build=true
   chef-client

Runtime:
ActiveDirectory users on the network, who are members of a declared security group, gain the warranted level of access. Users outside of the declared security group(s) are denied access.

Members of security groups declared in ['wt_portfolio_manager']['portmgr_group_admin'] may:
  * List, create, update, delete, search, sort, and paginate Portfolio Accounts, Portfolio Users, Streams configuration, and Data Sources.

Members of security group(s) declared in ['wt_portfolio_manager']['portmgr_group_user'] may:
  * List, search, sort, and paginate Portfolio Accounts and Portfolio Users.
  * Create, update, delete Portfolio Users.

