#
# Cookbook Name:: zookeeper
# Recipe:: default
# Author:: sean.mcnamara@webtrends.com / tim.smith@webtrends.com
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the needed components to prepare machine for db_index exe

include_recipe "java"
include_recipe "runit"

# setup zookeeper group
group "zookeeper" do
end

# setup zookeeper user
user "zookeeper" do
  comment "Zookeeper user"
  gid "zookeeper"
  home "/home/zookeeper"
  shell "/bin/bash"
  supports :manage_home => true
end

# create the install directory
directory "#{node[:zookeeper][:installDir]}" do
  owner "zookeeper"
  group "zookeeper"
  recursive true
  mode 00744
end

# create the data directory
directory "#{node[:zookeeper][:dataDir]}" do
  owner "zookeeper"
  group "zookeeper"
  recursive true
  mode 00744
end

# create the snapshot directory
directory "#{node[:zookeeper][:snapshotDir]}" do
  owner "zookeeper"
  group "zookeeper"
  recursive true
  mode 00744
end

# download zookeeper
remote_file "#{Chef::Config[:file_cache_path]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz" do
  source "#{node[:zookeeper][:sourceURL]}"
  owner "zookeeper"
  group "zookeeper"
  mode 00744
  action :create_if_missing
end

# extract it
execute "extract-zookeeper" do
  command "tar -zxf #{Chef::Config[:file_cache_path]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz"
  creates "#{node[:zookeeper][:installDir]}/zookeeper-#{node[:zookeeper][:version]}"
  cwd "#{node[:zookeeper][:installDir]}"
  user "zookeeper"
  group "zookeeper"
end

# create a link from the specific version to a generic zookeeper folder
link "#{node[:zookeeper][:installDir]}/current" do
  to "#{node[:zookeeper][:installDir]}/zookeeper-#{node[:zookeeper][:version]}"
end

# manage configs
%w[configuration.xsl log4j.properties zoo.cfg].each do |template_file|
  template "#{node[:zookeeper][:installDir]}/current/conf/#{template_file}" do
    source "#{template_file}"
    mode 00755
    owner "zookeeper"
    group "zookeeper"
    variables({
      :quorum => node[:zookeeper][:quorum]
    })
  end
end

# start script
template "#{node[:zookeeper][:installDir]}/current/bin/zkServer.sh" do
  source "zkServer.sh"
  mode 00755
  owner "zookeeper"
  group "zookeeper"
  variables({
    :java_jmx_port => 10201
  })
end
  
# myid
template "#{node[:zookeeper][:dataDir]}/myid" do
  source "myid"
  owner "zookeeper"
  group "zookeeper"
  mode 00755
end

# setup snapshot roller cron job
template "/etc/cron.hourly/zkRollSnapshot" do
  source "zkRollSnapshot"
  owner "zookeeper"
  group "zookeeper"
  mode 00555
end

#Create collectd plugin for zookeeper if collectd has been applied.
if node.attribute?("collectd")
  template "#{node[:collectd][:plugin_conf_dir]}/collectd_zookeeper.conf" do
    source "collectd_zookeeper.conf.erb"
    owner "root"
    group "root"
    mode 00644
    notifies :restart, resources(:service => "collectd")
  end
end