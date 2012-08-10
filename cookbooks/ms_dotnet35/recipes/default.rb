#
# Cookbook Name:: ms_dotnet35
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved
#

#Install .NET 3.5 Feature if we don't find part of the package already installed
if platform?("windows")
  if (win_version.windows_server_2008? || win_version.windows_server_2008_r2? || win_version.windows_7? || win_version.windows_vista?)
    if !File.exists?("C:/Windows/Microsoft.NET/Framework/v3.5")
      windows_feature "NetFx3" do
        action :install
      end
    end
  elsif (win_version.windows_server_2003_r2? || win_version.windows_server_2003? || win_version.windows_xp?)
    Chef::Log.warn('The Microsoft .NET Framework 3.5 Chef recipe currently only supports Windows Vista, 7, 2008, and 2008 R2.')
  end
else
  Chef::Log.warn('Microsoft Framework .NET 3.5 can only be installed on the Windows platform.')
end