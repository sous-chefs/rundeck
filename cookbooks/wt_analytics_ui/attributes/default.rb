#
# Author:: Kendrick Martin(<kendrick.martin@webtrends.com>)
# Cookbook Name:: wt_analytics_ui
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

# build info
default['wt_analytics_ui']['artifact'] = 'AnalyticsUI.zip'
default['wt_analytics_ui']['tc_proj'] = 'Analytics'
default['wt_analytics_ui']['download_url'] = ''

# install subfolder
default['wt_analytics_ui']['install_dir'] = 'Analytics'

# iis settings
default['wt_analytics_ui']['website_name'] = 'Analytics'
default['wt_analytics_ui']['website_port'] = 80
default['wt_analytics_ui']['app_pool_name'] = 'Webtrends_Analytics'
default['wt_analytics_ui']['app_pool_private_memory'] = 3145728

# website settings
default['wt_analytics_ui']['custom_errors'] = 'On'
default['wt_analytics_ui']['bba_domain'] = 'blackberry.webtrends.com'

# cache settings
default['wt_analytics_ui']['cache_enabled'] = 'true'
default['wt_analytics_ui']['cache_region'] = 'A10'

# proxy settings
default['wt_analytics_ui']['proxy_enabled'] = 'true'
default['wt_analytics_ui']['proxy_address'] = 'http://pdxproxy.netiq.dmz:8080'

# app settings section
default['wt_analytics_ui']['ondemand_base_domain'] = 'ondemand.webtrends.com'
default['wt_analytics_ui']['beta'] = 'false'
default['wt_analytics_ui']['branding'] = 'Webtrends'
default['wt_analytics_ui']['tagbuilder_download_url'] = 'https://tagbuilder.webtrends.com/'
default['wt_analytics_ui']['tagbuilder_url_template'] = 'https://tagbuilder.webtrends.com/ws/{0}/{1}{2}'
default['wt_analytics_ui']['help_link'] = 'http://help.webtrends.com/{0}/analytics10/'
default['wt_analytics_ui']['show_profiling'] = 'false'
default['wt_analytics_ui']['reinvigorate_tracking_code'] = 'fv6b7-9x820v8963'
default['wt_analytics_ui']['fb_app_clientid'] = '103645866351316'
default['wt_analytics_ui']['fb_app_clientsecret'] = 'f856805656c4b27bef04dc49641dbd58'
default['wt_analytics_ui']['hmap_url'] = 'http://hmapi.netiq.dmz/'
default['wt_analytics_ui']['pdf_export_url'] = 'http://localhost:8080/PdfService/pdf'
# log4net settings
default['wt_analytics_ui']['log_level'] = 'INFO'

