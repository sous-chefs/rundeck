#
# Cookbook Name:: wt_dx
# Recipe:: post
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe performs post install actions on a DX system

installdir = node['wt_common']['installdir_windows']

execute "icacls" do
        command "icacls \"#{installdir}\\Data Extraction API\" /grant:r IUSR:(oi)(ci)(rx)"
        action :run
end

execute "icacls" do
        command "icacls \"#{installdir}\\OEM Data Extraction API\" /grant:r IUSR:(oi)(ci)(rx)"
        action :run
end

execute "aspnet_regiis" do
        command "%WINDIR%\\Microsoft.Net\\Framework64\\v4.0.30319\\aspnet_regiis -i -enable"
        action :run
end

execute "ServiceModelReg" do
        command "%WINDIR%\\Microsoft.Net\\Framework64\\v4.0.30319\\ServiceModelReg.exe -r"
        action :run
end        