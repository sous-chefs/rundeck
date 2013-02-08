#
# Cookbook Name:: wt_actioncenter
# Attributes:: default
# Author:: Marcus Vincent (<marcus.vincent@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#

default['wt_actioncenter']['app_pool'] = 'ActionCenter'
default['wt_actioncenter']['download_url'] = ''
default['wt_actioncenter']['static_download_url'] = ''
default['wt_actioncenter']['port'] = 80
default['wt_actioncenter']['log_level'] = 'INFO'
default['wt_actioncenter']['cache_enabled'] = 'false'
default['wt_actioncenter']['cache_region'] = 'ActionCenter'
default['wt_actioncenter']['static_content_appender'] = '/actioncenter/v1'
