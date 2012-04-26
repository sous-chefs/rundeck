#
# Cookbook Name:: wt_zeromq
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

include_recipe "wt_zeromq"
include_recipe "java"

node[:wt_jzeromq][:build_pkgs].each do |pkg|
  package pkg do
    action :install
    provider Chef::Provider::Package::Apt
  end
end

cookbook_file "/tmp/jzeromq-#{node[:wt_jzeromq][:version]}.tar.gz" do
  source "jzeromq-#{node[:wt_jzeromq][:version]}.tar.gz"
  mode   0644
  owner  "root"
  group  "root"
end

execute "tar" do
  user    "root"
  group   "root"
  cwd     "/tmp"
  command "tar zxf /tmp/jzeromq-#{node[:wt_jzeromq][:version]}.tar.gz"
end

execute "autogen" do
  user    "root"
  group   "root"
  cwd     "/tmp/jzeromq-#{node[:wt_jzeromq][:version]}"
  command "./autogen.sh"
end

execute "configure" do
  user    "root"
  group   "root"
  cwd     "/tmp/jzeromq-#{node[:wt_jzeromq][:version]}"
  command "./configure"
end

execute "make" do
  user    "root"
  group   "root"
  cwd     "/tmp/jzeromq-#{node[:wt_jzeromq][:version]}"
  command "make"
end

execute "make-install" do
  user    "root"
  group   "root"
  cwd     "/tmp/jzeromq-#{node[:wt_jzeromq][:version]}"
  command "make install"
end

directory "/tmp/jzeromq-#{node[:wt_jzeromq][:version]}" do
  action :delete
  recursive true
end

file "/tmp/jzeromq-#{node[:wt_jzeromq][:version]}.tar.gz" do
  action :delete
end
