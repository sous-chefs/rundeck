#
# Cookbook Name:: wt_actioncenter
# Recipe:: uninstall
# Author: Marcus Vincent(<marcus.vincent@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe uninstalls all ActionCenter WebAPI IIS sites
 
app_pool = node['wt_actioncenter']['app_pool']
install_dir = "#{node['wt_common']['install_dir_windows']}\\Webtrends.ActionCenter"
log_dir = "#{node['wt_common']['install_dir_windows']}\\logs"
 
# remove the app
iis_app 'ActionCenter' do
 path "/ActionCenter"
 application_pool app_pool
 action :delete
 ignore_failure true
end
 
# remove the site
iis_site 'ActionCenter' do
 action [:stop, :delete]
 ignore_failure true
end
 
# remove the pool
iis_pool app_pool do
 action [:stop, :delete]
 ignore_failure true
end
 
directory install_dir do
 recursive true
 action :delete
 ignore_failure true
end
 
directory log_dir do
 recursive true
 action :delete
 ignore_failure true
end
