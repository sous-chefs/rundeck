#
# Author:: Kendrick Martin(<kendrick.martin@webtrends.com>)
# Cookbook Name:: wt_sync
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default['wt_sync']['artifact'] = "SyncService.zip"
default['wt_sync']['tc_proj'] = "SyncService"
default['wt_sync']['service_name'] = "Webtrends Sync Service"
default['wt_sync']['service_binary'] = "Webtrends.SyncService.exe"
default['wt_sync']['install_dir'] = "\\syncservice\\bin"
default['wt_sync']['log_dir'] = "\\syncservice\\logs"