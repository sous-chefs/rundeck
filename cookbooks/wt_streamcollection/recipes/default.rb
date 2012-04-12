#
# Cookbook Name:: wt_streamingcollection
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

user         = node[:user]
group        = node[:group]
tarball      = node[:tarball]
log_dir      = "#{node['wt_common']['log_dir_linux']}/streamingcollection"
install_dir  = "#{node['wt_common']['install_dir_linux']}/streamingcollection"
download_url = node[:download_url]


directory "#{log_dir}" do
  owner "root"
  group "root"
  mode "0755"
  recursive true
  action :create
end

directory "#{install_dir}/bin" do
  owner "root"
  group "root"
  mode "0755"
  recursive true
  action :create
end

remote_file "/tmp/#{tarball}" do
  source download_url
  mode "0644"
end

execute "tar" do
  user  "root"
  group "root"
  cwd install_dir
  command "tar zxf /tmp/#{tarball}"
end

template "#{install_dir}/bin/streamingcollection" do
  source "streamingcollectionservice.erb"
  owner "root"
  group "root"
  mode  "0755"
end

runit_service "streamingcollection" do
  action :start
end

execute "delete_install_source" do
  user "root"
  group "root"
  run "rm -f /tmp/#{tarball}"
end