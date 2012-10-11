#
# Cookbook Name:: wt_platformscheduler
# Recipe:: default
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs VDM Scheduler Agent
#
if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploy first"  
  include_recipe "wt_platformscheduler::uninstall"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end


# source build
msi_name = node['wt_platformscheduler']['agent_msi']
build_url = "#{node['wt_common']['install_server']}#{node['wt_platformscheduler']['url']}Webtrends+VDM+Scheduler+Agent.msi"

# destinations
install_dir = "#{node['wt_common']['install_dir_windows']}\\common\\agent"
log_dir     = "#{node['wt_common']['installlog_dir_windows']}"

# get data bag items
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['system_user']
svcpass = auth_data['wt_common']['loader_pass']

# get parameters
master_host = node['wt_masterdb']['master_host']
sched_host = node['wt_masterdb']['sched_host']

Chef::Log.info "Source URL: #{build_url}"

# create the log directory
directory log_dir do
	recursive true
	action :create
end

# create the install directory
directory install_dir do
	recursive true
	action :create
end

if ENV["deploy_build"] == "true" then

	# execute the VDM scheduler Agent MSI
	windows_package "Webtrends VDM Scheduler Agent" do
		source build_url
		options "/l*v \"#{log_dir}\\#{msi_name}-Install.log\" SERVICEACCT=#{svcuser} SERVICEPASS=#{svcpass} AGENTMANAGERADDRESS=agentmanager.1@#{sched_host} BASEFOLDER=#{node['wt_common']['install_dir']} LOGTOFILE=true FILELOGGINGLEVEL=4 SCHEDULERADDRESS=scheduler2@#{sched_host} MASTER_HOST=#{master_host} STANDALONE=TRUE INSTALLDIR=\"#{install_dir}\""
		action :install
	end

	# grant the service user full access to the install directory
	wt_base_icacls install_dir do
		action :grant
		user svcuser
		perm :full
	end

	# set permissions for the log readers group to have read access to the install directory
	wt_base_icacls install_dir do
		action :grant
		user node['wt_common']['wrsread_group']
		perm :read
	end

end