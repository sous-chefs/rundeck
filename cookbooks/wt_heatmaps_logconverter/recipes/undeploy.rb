#
# Cookbook Name:: wt_heatmaps_logconverter
# Recipe:: undeploy
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

log_dir      = "#{node['wt_common']['log_dir_linux']}/wt_heatmaps_logconverter"
install_dir  = "#{node['wt_common']['install_dir_linux']}/wt_heatmaps_logconverter"

# stop the service
service "wt_heatmaps_logconverter" do
  action [:stop, :disable]
end

directory log_dir do
  recursive true
  action :delete
end

directory install_dir do
  recursive true
  action :delete
end