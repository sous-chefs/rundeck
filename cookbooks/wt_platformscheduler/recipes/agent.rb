#
# Cookbook Name:: wt_platformscheduler
# Recipe:: agent
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#
# This recipe installs VDM Scheduler Agent
#

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploy first"  
  include_recipe "wt_platformscheduler::agent_uninstall"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

# destinations
base_dir        = node['wt_common']['install_dir_windows']
install_dir     = "#{base_dir}\\common\\agent"
install_log_dir = node['wt_common']['install_log_dir_windows']

# get data bag items
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['system_user']
svcpass = auth_data['wt_common']['system_pass']

# get parameters
master_host = node['wt_masterdb']['master_host']
sched_host  = node['wt_platformscheduler']['host']

log "Source URL: #{node['wt_platformscheduler']['agent']['download_url']}"

msi = node['wt_platformscheduler']['agent']['msi']

# create the log directory
directory install_log_dir do
  recursive true
  action :create
end

# create the install directory
directory install_dir do
  recursive true
  action :create
end

wt_base_icacls install_dir do
  user svcuser
  perm :modify
  action :grant
end

wt_base_netlocalgroup 'Performance Monitor Users' do
  user svcuser
  returns [0, 2]
  action :add
end

if ENV["deploy_build"] == "true" then

  remote_file "#{Chef::Config[:file_cache_path]}/#{msi}" do
    source node['wt_platformscheduler']['agent']['download_url']
    mode 00644
  end

  msi_options =  "/l*v \"#{install_log_dir}\\#{msi}-Install.log\""
  msi_options << " INSTALLDIR=\"#{install_dir}\""
  msi_options << " MASTER_HOST=#{master_host} STANDALONE=True"
  msi_options << " SERVICEACCT=\"#{svcuser}\" SERVICEPASS=\"#{svcpass}\""
  msi_options << " SCHEDULERADDRESS=scheduler2@#{sched_host}"
  msi_options << " AGENTMANAGERADDRESS=agentmanager.1@#{sched_host}"
  msi_options << " BASEFOLDER=\"#{base_dir}\" LOGTOFILE=True FILELOGGINGLEVEL=4"

  # execute the VDM Scheduler Agent MSI
  windows_package 'WebtrendsVDMSchedulerAgent' do
    source "#{Chef::Config[:file_cache_path]}/#{msi}"
    options msi_options
    action :install
    notifies :start, 'service[WebtrendsAgent]', :immediately
  end	

  service 'WebtrendsAgent'

  share_wrs

end
