#
# Cookbook Name:: ms_dotnet4
# Recipe:: default
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# This recipe registers .NET 4 with IIS to install ISAPI filters


execute "aspnet_regiis" do
    command "%WINDIR%\\Microsoft.Net\\Framework64\\v4.0.30319\\aspnet_regiis -i -enable"
    action :run
end