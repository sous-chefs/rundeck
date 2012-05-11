#
# Cookbook Name:: storm
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#


# install dependency packages
%{unzip zeromq jzmq}.each do |pkg|
  package pkg do
    action :install
  end
end

# create the install directory
directory "#{node['storm']['install_dir']}" do
  action :create
  recursive true
end

# fetch the storm application tarball from the cookbook
cookbook_file "#{Chef::Config[:file_cache_path]}/storm-#{node['storm']['version']}.tar.gz" do
  source "storm-#{node['storm']['version']}.tar.gz"
  mode   00644
  owner  "root"
  group  "root"
end

# uncompress the application tarball into the install directory
execute "tar" do
  user    "root"
  group   "root"
  creates "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}"
  cwd     "#{node['storm']['install_dir']}"
  command "tar zxvf #{Chef::Config[:file_cache_path]}/storm-#{node['storm']['version']}.tar.gz"
end
