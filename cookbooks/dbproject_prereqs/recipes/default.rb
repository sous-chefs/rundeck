#
# Author:: Aaron Stanley (<aaron.stanley@webtrends.com>)
# Cookbook Name:: dbproject_prereqs
# Recipe:: default
#
# Copyright:: 2013 Webtrends
#
# Installs Pre-reqs for MS Visual Studio Database Project deploys using VSDBCMD to be installed on 64bit Windows
#

  %w{ native_client command_line_utils clr_types smo sql_compact64 sql_compact32 }.each do |pkg|

    windows_package node['dbproject_prereqs'][pkg]['package_name'] do
	source node['dbproject_prereqs'][pkg]['url']
	checksum node['dbproject_prereqs'][pkg]['checksum']
	installer_type :msi
	options "/quiet /norestart"
	action :install
      end
  end

