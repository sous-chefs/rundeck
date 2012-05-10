#
# Cookbook Name:: wt_streaminglogreplay
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

# include runit recipe so a service can be defined later
include_recipe "runit"

log_dir      = File.join("#{node['wt_common']['log_dir_linux']}", "streaminglogreplay")
install_dir  = File.join("#{node['wt_common']['install_dir_linux']}", "streaminglogreplay")

tarball      = node['wt_streaminglogreplay']['tarball']
java_home    = node['java']['java_home']
download_url = node['wt_streaminglogreplay']['download_url']
user = node['wt_streaminglogreplay']['user']
group = node['wt_streaminglogreplay']['group']

zookeeper_port = node['zookeeper']['clientPort']

log "Install dir: #{install_dir}"
log "Log dir: #{log_dir}"
log "Java home: #{java_home}"

# create the log directory
directory "#{log_dir}" do
  owner   user
  group   group
  mode    00755
  recursive true
  action :create
end

# create the bin directory
directory "#{install_dir}/bin" do
  owner "root"
  group "root"
  mode 00755
  recursive true
  action :create
end

# create the conf directory
directory "#{install_dir}/conf" do
  owner "root"
  group "root"
  mode 00755
  recursive true
  action :create
end

# download the application tarball
remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
  source download_url
  mode 00644
end

# uncompress the application tarball into the install directory
execute "tar" do
  user  "root"
  group "root" 
  cwd install_dir
  command "tar zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
end

template "#{install_dir}/bin/service-control" do
  source  "service-control.erb"
  owner "root"
  group "root"
  mode  00755
  variables({
    :log_dir => log_dir,
    :install_dir => install_dir,
    :java_home => java_home,
    :user => user,
    :java_class => "com.webtrends.streaming.LogReplayer",
    :java_jmx_port => 9999
  })
end

# grab the zookeeper nodes that are currently available
zookeeper_pairs = Array.new
if not Chef::Config.solo
    search(:node, "role:zookeeper AND chef_environment:#{node.chef_environment}").each do |n|
		zookeeper_pairs << n[:fqdn]
	end
end

# append the zookeeper client port (defaults to 2181)
i = 0
while i < zookeeper_pairs.size do
  zookeeper_pairs[i] = zookeeper_pairs[i].concat(":#{zookeeper_port}")
  i += 1
end

template "#{install_dir}/conf/kafka.properties" do
  source  "kafka.properties.erb"
  owner   "root"
  group   "root"
  mode    00644
  variables({
    :zookeeper_pairs => zookeeper_pairs
  })
end

# delete the application tarball
execute "delete_install_source" do
    user "root"
    group "root"
    command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
    action :run
end

# create a runit service
runit_service "streaminglogreplay" do
  options({
    :log_dir => log_dir,
    :install_dir => install_dir,
    :java_home => java_home,
    :user => user
  })
end
