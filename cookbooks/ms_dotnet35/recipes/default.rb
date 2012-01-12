
#
# Cookbook Name:: ms_dotnet35
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved
#

#Install .NET 3.5 Feature if we don't find part of the package arleady installed

if !File.exists?("C:/Windows/Microsoft.NET/Framework64/v2.0.50727/aspnet_regiis.exe")
    windows_feature "NetFx3" do
        action :install
    end
end