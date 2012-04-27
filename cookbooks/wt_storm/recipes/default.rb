#
# Cookbook Name:: wt_storm
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

include_recipe "wt_jzeromq"

node[:wt_storm][:build_pkgs].each do |pkg|
  package pkg do
    action :install
    provider Chef::Provider::Package::Apt
  end
end

cookbook_file "/tmp/storm-#{node[:wt_storm][:version]}.tar.gz" do
  source "storm-#{node[:wt_storm][:version]}.tar.gz"
  mode   0644
  owner  "root"
  group  "root"
end

execute "tar" do
  user    "root"
  group   "root"
  cwd     "/tmp"
  command "tar zxvf /tmp/storm-#{node[:wt_storm][:version]}.tar.gz"
end

directory "#{node[:wt_common][:install_dir_linux]}" do
  action :create
  recursive true
end

execute "install" do
  user    "root"
  group   "root"
  cwd     "/tmp/storm-#{node[:wt_storm][:version]}"
  command "mv /tmp/storm-#{node[:wt_storm][:version]} #{node[:wt_common][:install_dir_linux]}/storm"
end

