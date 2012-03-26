#
# Cookbook Name:: wt_platformscheduler
# Recipe:: default
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the needed components to full setup/configure the RoadRunner service

# source build
msi_name = node['wt_platformscheduler']['agent_msi']
build_url = "#{node['wt_common']['install_server']}#{node['wt_platformscheduler']['url']}Webtrends+VDM+Scheduler+Agent.msi"

# destinations
install_dir = "#{node['wt_common']['install_dir']}\\common\\agent"
log_dir     = "#{node['wt_common']['installlog_dir']}"

# get data bag items 
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['system_user']
svcpass = auth_data['wt_common']['loader_pass']

# get parameters
master_host = node['wt_common']['master_host']
sched_host = node['wt_common']['sched_host']

Chef::Log.info "Source URL: #{build_url}"

directory "#{log_dir}" do
	recursive true
	action :create
end

remote_file "#{Chef::Config[:file_cache_path]}\\WebtrendsVDMSchedulerAgent.msi" do
        source "#{build_url}"
end

windows_package "Webtrends VDM Scheduler Agent" do
        source "#{Chef::Config[:file_cache_path]}\\WebtrendsVDMSchedulerAgent.msi"
        options "/l*v \"#{log_dir}\\#{msi_name}-Install.log\" SERVICEACCT=#{svcuser} SERVICEPASS=#{svcpass} AGENTMANAGERADDRESS=agentmanager.1@#{sched_host} BASEFOLDER=#{node['wt_common']['install_dir']} LOGTOFILE=true FILELOGGINGLEVEL=4 SCHEDULERADDRESS=scheduler2@#{sched_host} MASTER_HOST=#{master_host} STANDALONE=TRUE INSTALLDIR=\"#{install_dir}\""
        action :install
end

# wt_base_icacls "#{log_dir}" do
	# action :grant
	# user svcuser 
	# perm :modify
# end
