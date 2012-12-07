Description
===========
Installs the Webtrends Portfolio Admin site on Windows servers

Requirements
============

Recipes to be installed prior to this cookbook. Should be included as part of the wt_portfolio_admin role.

* recipe[ms_dotnet4]
* role[iis]

Attributes
==========

* node['wt_common']['install_dir_windows'] - Windows install directory
* node['wt_common']['install_log_dir_windows'] - Directory for windows install logs
* node['wt_common']['http_proxy_url'] - HTTP Proxy location
* node['wt_cam']['cam_service_url'] - Location of CAM service.
* node['wt_sauth']['auth_service_url'] - Location of Auth service.
* node['wt_streamingapi']['sapi_service_url'] - Location of SAPI service. (Not sure if required)
* node['wt_streaming_viz']['streams_ui_url'] - Location of Streaming Viz UI

* node['wt_portfolio_admin']['app_pool'] - Name to assign the app pool for the hosting IIS app.
* node['wt_portfolio_admin']['download_url'] - Location of deployable artifacts.
* node['wt_portfolio_admin']['port'] - HTTP port for IIS application. (Default: 80)
* node['wt_portfolio_admin']['log_level'] - log4net logging level. (Default: INFO)
* node['wt_portfolio_admin']['elmah_remote_access'] - yes/no allow remote access to ELMAH error pages
* node['wt_portfolio_admin']['custom_errors'] - On/Off to show or hide custom error pages.
* node['wt_portfolio_admin']['proxy_enabled'] - true/false to enable or disable using HTTP proxy.
* node['wt_portfolio_admin']['auth_service_url_base'] - Path to auth service API. ('/token', deprecated)
* node['wt_portfolio_admin']['auth_service_version'] - Version of auth service to use.
* node['wt_portfolio_admin']['cam_service_url_base'] - Common path to CAM API endpoints. ('', deprecated)
* node['wt_portfolio_admin']['account_ui_url'] - Brower URL for this service

Data Bag Items
==============

* authorization['wt_common']['ui_user'] - User under which the service will run
* authorization['wt_portfolio_admin']['client_id'] - Portfolio Admin client ID
* authorization['wt_portfolio_admin']['client_secret'] - Portfolio Admin client secret
* authorization['wt_iis']['machine_validation_key'] - IIS Machine key configuration for auth ticket
* authorization['wt_iis']['machine_decryption_key'] - IIS Machine key configuration for auth ticket

Usage
=====
`set deploy_build=true`
`chef-client`

