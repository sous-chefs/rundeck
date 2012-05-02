#
# Cookbook Name:: storm
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

include_recipe "jzeromq"

# install dependency packages for the build
%{unzip}.each do |pkg|
  package pkg do
    action :install
  end
end

cookbook_file "/tmp/storm-#{node[:wt_storm][:version]}.tar.gz" do
  source "storm-#{node[:storm][:version]}.tar.gz"
  mode   0644
  owner  "root"
  group  "root"
end

execute "tar" do
  user    "root"
  group   "root"
  cwd     "/tmp"
  command "tar zxvf /tmp/storm-#{node[:storm][:version]}.tar.gz"
end

directory "#{node[:storm][:install_dir]}" do
  action :create
  recursive true
end

execute "install" do
  user    "root"
  group   "root"
  cwd     "/tmp/storm-#{node[:storm][:version]}"
  command "mv /tmp/storm-#{node[:storm][:version]} #{node[:storm][:install_dir]}"
end

