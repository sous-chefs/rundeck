#
# Cookbook Name:: nscp
# Recipe:: default
#
# Copyright 2012, Tim Smith - Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

if platform?("windows")
  windows_package "NSClient++ (x64)" do
    source node['nscp']['http_url']
    action :install
  end
else
  Chef::Log.warn('nscp can only be installed on the Windows platform.')
end