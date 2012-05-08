#
# Cookbook Name:: jzeromq
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

include_recipe "zeromq"
include_recipe "java"

%w{build-essential uuid-dev autogen pkg-config libtool autoconf automake}.each do |pkg|
  package pkg do
    action :install
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/jzeromq-#{node[:jzeromq][:version]}.tar.gz" do
  source "#{node[:jzeromq][:download_url]}/jzeromq-#{node[:jzeromq][:version]}.tar.gz"
  mode 00644
end

execute "tar" do
  user    "root"
  group   "root"
  cwd     "#{Chef::Config[:file_cache_path]}"
  command "tar zxf #{Chef::Config[:file_cache_path]}/jzeromq-#{node[:jzeromq][:version]}.tar.gz"
end

execute "autogen" do
  user    "root"
  group   "root"
  cwd     "#{Chef::Config[:file_cache_path]}/jzeromq-#{node[:jzeromq][:version]}"
  command "./autogen.sh"
end

execute "configure" do
  user    "root"
  group   "root"
  cwd     "#{Chef::Config[:file_cache_path]}/jzeromq-#{node[:jzeromq][:version]}"
  command "./configure"
end

execute "make" do
  user    "root"
  group   "root"
  cwd     "#{Chef::Config[:file_cache_path]}/jzeromq-#{node[:jzeromq][:version]}"
  command "make"
end

execute "make-install" do
  user    "root"
  group   "root"
  cwd     "#{Chef::Config[:file_cache_path]}/jzeromq-#{node[:jzeromq][:version]}"
  command "make install"
end

directory "#{Chef::Config[:file_cache_path]}/jzeromq-#{node[:jzeromq][:version]}" do
  action :delete
  recursive true
end

file "#{Chef::Config[:file_cache_path]}/jzeromq-#{node[:jzeromq][:version]}.tar.gz" do
  action :delete
end
