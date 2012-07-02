#
# Cookbook Name:: firefox
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved
#
# Code based off the PowerShell cookbook by Seth Chisamore

if platform?("windows")
    windows_package "Mozilla Firefox 13.0.1 (x86 en-US)" do
        source node['firefox']['http_url']
        installer_type :custom
        options "-ms"
        action :install
    end
else
  Chef::Log.warn('Firefox can only be installed on the Windows platform using this cookbook.')
end