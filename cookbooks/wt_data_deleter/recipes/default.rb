#
# Cookbook Name:: wt_data_deleter
# Recipe:: default
# Author:: Michael Parsons
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

require 'win32/service'

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploying first"
  include_recipe "wt_data_deleter::uninstall"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

# get parameters
download_url = node['wt_data_deleter']['download_url']

# destinations
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_data_deleter']['install_dir']).gsub(/[\\\/]+/,"\\")
log_dir     = File.join(node['wt_common']['install_dir_windows'], node['wt_data_deleter']['log_dir']).gsub(/[\\\/]+/,"\\")

# get data bag items
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
  perm :read
  action :grant
end

# create product log directory
directory log_dir do
  recursive true
  action :create
end

wt_base_icacls log_dir do
  user svcuser
  perm :modify
  action :grant
end

if ENV["deploy_build"] == "true" then

  # Platform Scheduler Agent must be running
  ruby_block 'WebtrendsAgent_status' do
    block do
      raise 'WebtrendsAgent is not running' unless Win32::Service.status('WebtrendsAgent').current_state == 'running'
    end
  end

  #ENV['deploy_build'] = 'false'
  log "Source URL: #{download_url}"

  # unzip the install package
  windows_zipfile install_dir do
    source download_url
    action :unzip
  end

  template "#{install_dir}\\DataDeleter.exe.config" do
    source "DataDeleter.exe.config.erb"
    variables(
      :report_column    => node['cassandra']['cassandra_report_column'],
      :metadata_column  => node['cassandra']['cassandra_meta_column'],
      :cass_thrift_port => node['cassandra']['cassandra_thrift_port'],
      :cass_host        => node['cassandra']['cassandra_host'],
      :hbase_location   => node['hbase']['location'],
      :hbase_dc_id      => node['wt_analytics_ui']['fb_data_center_id'],
      :hbase_pod_id     => node['wt_common']['pod_id']
    )
  end

  template "#{install_dir}\\DeletionScheduler.exe.config" do
    source "DeletionScheduler.exe.config.erb"
    variables(
      :master_host      => node['wt_masterdb']['master_host'],
      :report_column    => node['cassandra']['cassandra_report_column'],
      :metadata_column  => node['cassandra']['cassandra_meta_column'],
      :cass_thrift_port => node['cassandra']['cassandra_thrift_port'],
      :cass_host        => node['cassandra']['cassandra_host'],
      :hbase_location   => node['hbase']['location'],
      :hbase_dc_id      => node['wt_analytics_ui']['fb_data_center_id'],
      :hbase_pod_id     => node['wt_common']['pod_id']
    )
  end

  datadeleter = File.join(install_dir, node['wt_data_deleter']['datadeleter_binary']).gsub(/[\\\/]+/,"\\")
  execute node['wt_data_deleter']['datadeleter_binary'] do
    command "#{datadeleter} --install"
  end

  deletionscheduler = File.join(install_dir, node['wt_data_deleter']['deletionscheduler_binary']).gsub(/[\\\/]+/,"\\")
  execute node['wt_data_deleter']['deletionscheduler_binary'] do
    command "#{deletionscheduler} --install"
  end

  share_wrs

end
