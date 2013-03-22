#
# Author:: Aaron Stanley (<aaron.stanley@webtrends.com>)
# Cookbook Name:: vsdbcmd
# Recipe:: default
#
# Copyright:: 2013 Webtrends
#
# Installs Pre-reqs for MS Visual Studio Database Project deploys using VSDBCMD to be installed on 64bit Windows
#

  %w{ native_client command_line_utils clr_types smo sql_compact32 sql_compact64 }.each do |pkg|

    windows_package node['vsdbcmd'][pkg]['package_name'] do
	source node['vsdbcmd'][pkg]['url']
	checksum node['vsdbcmd'][pkg]['checksum']
	installer_type :msi
	options "IACCEPTSQLNCLILICENSETERMS=#{node['vsdbcmd']['native_client']['accept_eula'] ? 'YES' : 'NO'}"
	action :install
      end
  end

