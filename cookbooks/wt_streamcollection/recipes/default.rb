#
# Cookbook Name:: wt_scs
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

name         = node[:name]
user         = node[:user]
group        = node[:group]
tarball      = node[:tarball]
log_dir      = node[:log_dir]
install_dir  = node[:install_dir]
download_url = node[:download_url]

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

directory "#{log_dir}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

directory "#{install_dir}/#{name}/bin" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

template "#{install_dir}/#{name}/bin/#{name}" do
  source "#{name}.erb"
  owner "root"
  group "root"
  mode  "0755"
end

runit_service "#{name}" do
  action :start
end

execute "delete_install_source" do
  user "root"
  group "root"
  run "rm -f /tmp/#{tarball}"
end

