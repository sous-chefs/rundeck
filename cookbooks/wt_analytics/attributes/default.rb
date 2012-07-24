#
# Author:: Kendrick Martin(<kendrick.martin@webtrends.com>)
# Cookbook Name:: wt_analytics
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

# build info
default['wt_analytics']['artifact'] = 'AnalyticsUI.zip'
default['wt_analytics']['tc_proj'] = 'Analytics'
default['wt_analytics']['download_url'] = 'http://teamcity.webtrends.corp/guestAuth/repository/download/bt15/.lastSuccessful/AnalyticsUI.zip'

# install subfolder
default['wt_analytics']['install_dir'] = 'Insight'

# iis settings
default['wt_analytics']['website_name'] = 'Analytics'
default['wt_analytics']['website_port'] = 80
default['wt_analytics']['app_pool_name'] = 'Webtrends_Analytics'
default['wt_analytics']['app_pool_private_memory'] = 3145728

# website settings
default['wt_analytics']['custom_errors'] = 'On'
default['wt_analytics']['bba_domain'] = 'blackberry.webtrends.com'

# cache settings
default['wt_analytics']['cache_enabled'] = 'true'
default['wt_analytics']['cache_region'] = 'A10'

# proxy settings
default['wt_analytics']['proxy_enabled'] = 'true'
default['wt_analytics']['proxy_address'] = 'http://pdxproxy.netiq.dmz:8080'

# app settings section
default['wt_analytics']['rest_base_uri'] = 'https://ws.webtrends.com/v3'
default['wt_analytics']['ondemand_base_domain'] = 'ondemand.webtrends.com'
default['wt_analytics']['beta'] = 'false'
default['wt_analytics']['branding'] = 'Webtrends'
default['wt_analytics']['tagbuilder_download_url'] = 'https://tagbuilder.webtrends.com/'
default['wt_analytics']['tagbuilder_url_template'] = 'https://tagbuilder.webtrends.com/ws/{0}/{1}{2}'
default['wt_analytics']['help_link'] = 'http://help.webtrends.com/{0}/analytics10/'
default['wt_analytics']['show_profiling'] = 'false'
default['wt_analytics']['reinvigorate_tracking_code'] = 'fv6b7-9x820v8963'
default['wt_analytics']['fb_app_clientid'] = '103645866351316'
default['wt_analytics']['fb_app_clientsecret'] = 'f856805656c4b27bef04dc49641dbd58'
default['wt_analytics']['hmap_url'] = 'http://hmapi.netiq.dmz/'
