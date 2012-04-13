#
# Cookbook Name:: wt_dx
# Recipe:: version21
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe sets DX 2.1

# Find all memcached nodes in the same environment with search
c_hosts = cache_hosts = search(:node, "chef_environment:#{node.chef_environment} AND recipes:memcached")

#Recipe specific
cfg_cmds = node['wt_dx']['v2_1']['cfg_cmd']
app_pool = node['wt_dx']['v2_1']['app_pool']
installdir = node['wt_common']['installdir']
installdir_v21 = node['wt_dx']['v2_1']['dir']

pod = node.chef_environment
user_data = data_bag_item('authorization', pod)
ui_user = user_data['wt_common']['ui_user']
ui_password = user_data['wt_common']['ui_pass']
auth_cmd = "/section:applicationPools /[name='#{app_pool}'].processModel.identityType:SpecificUser /[name='#{app_pool}'].processModel.userName:#{ui_user} /[name='#{app_pool}'].processModel.password:#{ui_password}"

template "#{installdir}#{installdir_v21}\\web.config" do
	source "webConfigv21.erb"
	variables(
		:cache_hosts => c_hosts
	)
end

iis_pool "#{app_pool}" do
	thirty_two_bit :true
action [:add, :config]
end

iis_app "DX" do
	path "/v2_1"
	application_pool "#{app_pool}"
	physical_path "#{installdir}#{installdir_v21}"
	action :add
end

iis_config auth_cmd do
	action :config
end