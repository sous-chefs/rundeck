#
# Cookbook Name:: wt_zeromq
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

node[:wt_zeromq][:build_pkgs].each do |pkg|
  package pkg do
    action :install
  end
end

cookbook_file "/tmp/zeromq-#{node[:wt_zeromq][:version]}.tar.gz" do
  source "zeromq-#{node[:wt_zeromq][:version]}.tar.gz"
  mode   00644
  owner  "root"
  group  "root"
end

execute "tar" do
  user    "root"
  group   "root"
  cwd     "/tmp"
  command "tar zxf /tmp/zeromq-#{node[:wt_zeromq][:version]}.tar.gz"
end

execute "configure" do
  user    "root"
  group   "root"
  cwd     "/tmp/zeromq-#{node[:wt_zeromq][:version]}"
  command "./configure"
end

execute "make" do
  user    "root"
  group   "root"
  cwd     "/tmp/zeromq-#{node[:wt_zeromq][:version]}"
  command "make"
end

execute "make-install" do
  user    "root"
  group   "root"
  cwd     "/tmp/zeromq-#{node[:wt_zeromq][:version]}"
  command "make install"
end

directory "/tmp/zeromq-#{node[:wt_zeromq][:version]}" do
  action :delete
  recursive true
end

file "/tmp/zeromq-#{node[:wt_zeromq][:version]}.tar.gz" do
  action :delete
end