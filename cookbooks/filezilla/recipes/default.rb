#
# Cookbook Name:: filezilla
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved
#
# Code based off the PowerShell cookbook by Seth Chisamore

if platform?("windows")
    windows_package "FileZilla Client 3.5.3" do
        source node['filezilla']['http_url']
        installer_type :custom
        options "/S /user=all"
        action :install
    end
else
  Chef::Log.warn('FileZilla Client can only be installed on the Windows platform using this cookbook.')
end