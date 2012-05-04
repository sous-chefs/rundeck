#
# Cookbook Name:: zeromq
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

# Packages which need to be installed on the system
# to allow for compilation of ZeroMQ.
%w{build-essential uuid-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/zeromq-#{node[:zeromq][:version]}.tar.gz" do
  source "#{node[:zeromq][:download_url]}/zeromq-#{node[:zeromq][:version]}.tar.gz"
  mode 00644
end

execute "tar" do
  user    "root"
  group   "root"
  cwd     "#{Chef::Config[:file_cache_path]}"
  command "tar zxf #{Chef::Config[:file_cache_path]}/zeromq-#{node[:zeromq][:version]}.tar.gz"
end

execute "configure" do
  user    "root"
  group   "root"
  cwd     "#{Chef::Config[:file_cache_path]}/zeromq-#{node[:zeromq][:version]}"
  command "./configure"
end

execute "make" do
  user    "root"
  group   "root"
  cwd     "#{Chef::Config[:file_cache_path]}/zeromq-#{node[:zeromq][:version]}"
  command "make"
end

execute "make-install" do
  user    "root"
  group   "root"
  cwd     "#{Chef::Config[:file_cache_path]}/zeromq-#{node[:zeromq][:version]}"
  command "make install"
end

directory "#{Chef::Config[:file_cache_path]}/zeromq-#{node[:zeromq][:version]}" do
  action :delete
  recursive true
end

file "#{Chef::Config[:file_cache_path]}/zeromq-#{node[:zeromq][:version]}.tar.gz" do
  action :delete
end