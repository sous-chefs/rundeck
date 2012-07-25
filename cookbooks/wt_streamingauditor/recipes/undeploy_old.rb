#
# Cookbook Name:: wt_streamingauditor
# Recipe:: undeploy
# NOTES: This recipe is included until the old service has gone through an install cycle on each 
# of the environments. At that time this receip can be deleted.
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

log_dir      = "#{node['wt_common']['log_dir_linux']}/streamingaudit"
install_dir  = "#{node['wt_common']['install_dir_linux']}/streamingaudit"

execute "nuke" do
    command "sudo sv stop streamingaudit ; sudo rm -rf /etc/sv/streamingaudit ; sudo rm -rf /etc/service/streamingaudit"
    action :run
    user "root"
    group "root"
end

directory "#{log_dir}" do
  recursive true
  action :delete
end

directory "#{install_dir}" do
  recursive true
  action :delete
end