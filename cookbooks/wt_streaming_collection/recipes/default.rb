#
# Cookbook Name:: wt_streaming_collection
# Recipe:: default
#
# Copyright 2013, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploying first"
  include_recipe "wt_streaming_collection::undeploy"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

install_dir  = File.join(node['wt_portfolio_harness']['plugin_dir'], "streaming_collection")
conf_dir     = File.join(install_dir, "conf")
cache_dir    = File.join(install_dir, "cache")
tarball      = node['wt_streaming_collection']['download_url'].split("/")[-1]
download_url = node['wt_streaming_collection']['download_url']
user         = node['wt_streaming_collection']['user']
group        = node['wt_streaming_collection']['group']
config_url   = node['wt_streamingconfigservice']['config_service_url']
pod = node['wt_realtime_hadoop']['pod']
datacenter = node['wt_realtime_hadoop']['datacenter']

log "Install dir: #{install_dir}"

# create the directories
[install_dir, conf_dir, cache_dir].each do |dir|
  directory dir do
    owner "root"
    group "root"
    mode 00755
    recursive true
    action :create
  end
end

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so we will grab the tar ball and install"

  # download the application tarball
  remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
    source download_url
    mode 00644
  end

  # uncompress the application tarball into the install dir
  execute "tar" do
    user  "root"
    group "root"
    cwd install_dir
    command "tar zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
    notifies :restart, "service[harness]", :delayed
  end

  # delete the install tar ball
  execute "delete_install_source" do
    user "root"
    group "root"
    command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
    action :run
  end
end

#Template kafka.properties
template "#{conf_dir}/kafka.properties" do
    source  "kafka.properties.erb"
    owner   "root"
    group   "root"
    mode    00644
    variables({
      :kafka_topic_scs => "#{datacenter}_#{pod}_scsRawHits",
      :kafka_topic_dc => "#{datacenter}_#{pod}_dcRawHits"
    })
end

#Template config.properties
template "#{conf_dir}/config.properties" do
    source  "config.properties.erb"
    owner   "root"
    group   "root"
    mode    00644
    variables({
      :configservice => "#{config_url}"
    })
end
