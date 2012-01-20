#
# Cookbook Name:: notepadplusplus
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved
#
# Code based off the PowerShell cookbook by Seth Chisamore

case node['platform']
when "windows"
    windows_package "Notepad Plus Plus" do
        source node['notepadplusplus']['http_url']
        installer_type :custom
        options "/S"
        action :install
    end
else
  Chef::Log.warn('Notepad++ can only be installed on the Windows platform.')
end
