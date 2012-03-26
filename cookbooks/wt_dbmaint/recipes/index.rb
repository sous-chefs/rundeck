#
# Cookbook Name:: wt_dbmaint
# Recipe:: index
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the needed components to prepare machine for db_index exe

# source build
zip_name = node['wt_dbmaint']['index_file']
build_url = "#{node['wt_common']['install_server']}#{node['wt_dbmaint']['url']}#{zip_name}"

# destinations
install_dir = "#{node['wt_common']['install_dir']}\\modules\\VDMIndex"

# get data bag items 
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['system_user']
svcpass = auth_data['wt_common']['loader_pass']

# get parameters
master_host = node['wt_common']['master_host']
sched_host = node['wt_common']['sched_host']

Chef::Log.info "Source URL: #{build_url}"

windows_zipfile "#{install_dir}" do
	source "#{build_url}"
	action :unzip	
end

# wt_base_icacls "#{log_dir}" do
	# action :grant
	# user svcuser 
	# perm :modify
# end
