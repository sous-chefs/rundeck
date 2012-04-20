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
  mode "0744"
end

# create the data directory
directory "#{node[:zookeeper][:dataDir]}" do
  owner "zookeeper"
  group "zookeeper"
  recursive true
  mode "0744"
end

# create the snapshot directory
directory "#{node[:zookeeper][:snapshotDir]}" do
  owner "zookeeper"
  group "zookeeper"
  recursive true
  mode "0744"
end

# download zookeeper
remote_file "#{Chef::Config[:file_cache_path]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz" do
  source "#{default[:zookeeper][:sourceURL]}"
  owner "zookeeper"
  group "zookeeper"
  mode "0744"
  action :create_if_missing
end

# extract it
execute "extract-zookeeper" do
  command "tar -zxf #{Chef::Config[:file_cache_path]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz"
  creates "zookeeper-#{node[:zookeeper][:version]}"
  cwd "#{node[:zookeeper][:installDir]}"
  user "zookeeper"
  group "zookeeper"
end

link "/usr/local/zookeeper" do
  to "#{node[:zookeeper][:installDir]}/zookeeper-#{node[:zookeeper][:version]}"
end

# manage configs
%w[configuration.xsl log4j.properties zoo.cfg].each do |template_file|
  template "/usr/local/zookeeper/conf/#{template_file}" do
    source "#{template_file}"
    mode 0755
    owner "zookeeper"
    group "zookeeper"
  end
end

# myid
template "#{node[:zookeeper][:dataDir]}/myid" do
  source "myid"
  owner "zookeeper"
  group "zookeeper"
  mode 0755
end

# snapshot roller
template "/etc/cron.daily/zkRollSnapshot.sh" do
  source "zkRollSnapshot.sh"
  owner "zookeeper"
  group "zookeeper"
  mode 0544
end

runit_service "zookeeper"