#
# Cookbook Name:: powergui
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved
#
# Code based off the PowerShell cookbook by Seth Chisamore

if platform?("windows")
    windows_package "Quest PowerGUI\® 3.2" do
        source node['powergui']['http_url']
        installer_type :msi
        action :install
    end
else
  Chef::Log.warn('PowerGUI can only be installed on the Windows platform using this cookbook.')
end