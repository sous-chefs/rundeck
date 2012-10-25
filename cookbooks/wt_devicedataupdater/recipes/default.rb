#
# Cookbook Name:: wt_devicedataupdater
# Recipe:: default
# Author:: Tim Smith
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#
# This recipe installs the needed components to full setup/configure the Device Data Updater executeable
#

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploying first"
  include_recipe "wt_devicedataupdater::uninstall"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

# get parameters
download_url = node['wt_devicedataupdater']['download_url']
master_host = node['wt_masterdb']['master_host']

# destinations
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_devicedataupdater']['install_dir'].gsub(/[\\\/]+/,"\\"))
log_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_devicedataupdater']['log_dir'].gsub(/[\\\/]+/,"\\"))

auth_data = data_bag_item('authorization', node.chef_environment)

# determine root drive of install_dir - ENG390500
if (install_dir =~ /^(\w:)\\.*$/)
  install_dir_drive = $1
else
  raise Chef::Exceptions::AttributeNotFound,
    "could not determine install_dir_drive, please verify value of install_dir: #{install_dir}"
end

# create the install directory
directory install_dir do
  recursive true
  action :create
end

# set permissions for the service user to have read access to the install drive - ENG390500
wt_base_icacls install_dir_drive do
  action :grant
  user svcuser
  perm :read
end

# create the log directory
directory log_dir do
  recursive true
  action :create
end

# allow the service account to modify files in the log directory
wt_base_icacls log_dir do
  action :grant
  user svcuser
  perm :modify
end

if deploy_mode?

  ENV['deploy_build'] = 'false'
  # log("Source URL: #{build_url}") { level :info}
  this_zipfile = get_build node['wt_devicedataupdater']['zip_file']

  # unzip the install package
  windows_zipfile install_dir do
    source "#{this_zipfile}"
    action :unzip
  end

  template "#{install_dir}\\Webtrends.RoadRunner.Service.exe.config" do
    source "RRServiceConfig.erb"
    variables(
      :master_host => master_host
    )
  end

  template "#{install_dir}\\log4net.config" do
    source "log4net.erb"
    variables(
      :logdir => log_dir
    )
  end

  share_wrs
end

