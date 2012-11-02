#
# Cookbook Name:: wt_devicedataupdater
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#
# This recipe installs the needed components to full setup/configure the Device Data Updater executeable
#

require 'win32/service'

if ENV['deploy_build'] == 'true' then
  log 'The deploy_build value is true so un-deploying first'
  include_recipe 'wt_devicedataupdater::uninstall'
else
  log 'The deploy_build value is not set or is false so we will only update the configuration'
end

# get parameters
download_url = node['wt_devicedataupdater']['download_url']

# destinations
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_devicedataupdater']['install_dir']).gsub(/[\\\/]+/,"\\")
log_dir     = File.join(node['wt_common']['install_dir_windows'], node['wt_devicedataupdater']['log_dir']).gsub(/[\\\/]+/,"\\")

auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['system_user']
svcpass = auth_data['wt_common']['system_pass']

# create the install directory
directory install_dir do
  recursive true
  action :create
end

wt_base_icacls install_dir do
  user svcuser
  perm :full
  action :grant
end

# create the log directory
directory log_dir do
  recursive true
  action :create
end

wt_base_icacls log_dir do
  user svcuser
  perm :modify
  action :grant
end

if deploy_mode?

  # Platform Scheduler Agent must be running
  ruby_block 'WebtrendsAgent_status' do
    block do
      raise 'WebtrendsAgent is not running' unless Win32::Service.status('WebtrendsAgent').current_state == 'running'
    end
  end

  ENV['deploy_build'] = 'false'
  log "Source URL: #{download_url}"

  # unzip the install package
  windows_zipfile install_dir do
      source download_url
      action :unzip
  end

  # full path to DDU.exe
  ddu = File.join(install_dir, node['wt_devicedataupdater']['service_binary']).gsub(/[\\\/]+/,"\\")
  execute node['wt_devicedataupdater']['service_binary'] do
    command "#{ddu} -install"
  end

  share_wrs

end

template "#{install_dir}\\DDU.exe.config" do
	source "DeviceDataUpdater.exe.config.erb"
	variables ({
		:archivedir => "#{node['wt_common']['config_share']}\\WTL021014000002\\component\\plugins\\DeviceLookupPlugin\\archive",
		:outputdir => "#{node['wt_common']['config_share']}\\WTL021014000002\\component\\plugins\\DeviceLookupPlugin"
	})
end

