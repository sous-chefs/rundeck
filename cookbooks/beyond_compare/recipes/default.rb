#
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
# Cookbook Name:: beyond_compare
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

# files needed to assist silent install
key_file = "#{Chef::Config[:file_cache_path]}/BC3Key.txt"
inf_file = "#{Chef::Config[:file_cache_path]}/bc3inf.txt"

# is beyond compare installed?
is_installed = in_reg_uninstall? node['beyond_compare']['display_name']

# license key from authorization data bag
unless is_installed
  key_data = wt_auth['beyond_compare_v3']['license_key'].join("\n") rescue nil
  raise Chef::Exceptions::AttributeNotFound, "No license key provided for beyond compare." if key_data.nil?
end

# setup inf file
cookbook_file inf_file do
  source "bc3inf.txt"
  backup false
  action :create
  not_if { is_installed }
end

# license key file
file key_file do
  content key_data
  backup false
  action :create
  not_if { is_installed }
end

# install
windows_package node['beyond_compare']['display_name'] do
  source node['beyond_compare']['download_url']
  options "/sp- /verysilent /loadinf=\"#{inf_file}\""
  installer_type :custom
  action :install
end

# remove key file
file "rm key_file" do
  path key_file
  backup false
  action :delete
end

# remove inf file
file "rm inf_file" do
  path inf_file
  backup false
  action :delete
end
