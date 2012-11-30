#
# Cookbook Name:: wt_portfolio_manager
# Recipe:: uninstall
# Author: Toby Mosby(<toby.mosby@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe uninstalls all DX versions

app_pool = node['wt_portfolio_manager']['app_pool']
install_dir = "#{node['wt_common']['install_dir_windows']}\\Webtrends.Portfolio.Manager"
log_dir = "#{node['wt_common']['install_dir_windows']}\\logs"

# remove the app
# iis_app 'PortfolioAdmin' do
# 	path "/"
# 	application_pool "#{app_pool}"
# 	action :delete
# end

# remove the site
iis_site 'PortfolioManager' do
	action [:stop, :delete]
    ignore_failure true
end

# remove the pool
iis_pool app_pool do
  action [:stop, :delete]
  # ignore errors for now since the resource search will match CAMService when searching for CAM (this is fixed in IIS cookbook v1.2)
  ignore_failure true
end

directory install_dir do
  recursive true
  action :delete
end

directory log_dir do
  recursive true
  action :delete
end
