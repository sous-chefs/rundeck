#
# Cookbook Name:: wt_oauth_redirector
# Recipe:: uninstall
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

log_dir     = File.join("#{node['wt_common']['log_dir_linux']}", "oauth_redirector")
install_dir = File.join("#{node['wt_common']['install_dir_linux']}", "oauth_redirector")
stop_cmd = "thin stop -C #{install_dir}/oard.thin.yml"

execute "stop application" do
  command stop_cmd
  action :run
  ignore_failure true
end

directory install_dir do
  recursive true
  action :delete
end
