#
# Cookbook Name:: wt_actioncenter_ddp
# Recipe:: undeploy
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

install_dir  =
"#{node['wt_common']['install_dir_linux']}/harness/plugins/actioncenter_ddp"

directory install_dir do
  recursive true
  action :delete
end
