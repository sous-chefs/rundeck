# Author:: Aaron Stanley (<aaron.stanley@webtrends.com>)
# Cookbook Name:: vsdbcmd
# Attribute:: default
#
# Copyright:: Copyright (c) 2013 Webtrends Inc.
#
#

  default['vsdbcmd']['native_client']['url']               = 'http://download.microsoft.com/download/sqlncli_x64.msi'
  default['vsdbcmd']['native_client']['checksum']          = ''
  default['vsdbcmd']['native_client']['package_name']      = 'Microsoft SQL Server 2008 R2 Native Client'

  default['vsdbcmd']['command_line_utils']['url']          = 'http://download.microsoft.com/download/SqlCmdLnUtils.msi'
  default['vsdbcmd']['command_line_utils']['checksum']     = ''
  default['vsdbcmd']['command_line_utils']['package_name'] = 'Microsoft SQL Server 2008 R2 Command Line Utilities'

  default['vsdbcmd']['clr_types']['url']                   = 'http://download.microsoft.com/download/SQLSysClrTypes_x64.msi'
  default['vsdbcmd']['clr_types']['checksum']              = ''
  default['vsdbcmd']['clr_types']['package_name']          = 'Microsoft SQL Server System CLR Types (x64)'

  default['vsdbcmd']['smo']['url']                         = 'http://download.microsoft.com/download/SharedManagementObjects_x64.msi'
  default['vsdbcmd']['smo']['checksum']                    = ''
  default['vsdbcmd']['smo']['package_name']                = 'Microsoft SQL Server 2008 R2 Management Objects (x64)'

  default['vsdbcmd']['sql_compact64']['url']	             = 'http://download.microsoft.com/download/SSCERuntime_x64-ENU.msi'
  default['vsdbcmd']['sql_compact64']['checksum']          = ''
  default['vsdbcmd']['sql_compact64']['package_name']      = 'Microsoft SQL Server Compact 3.5 SP2 x64 ENU'

  default['vsdbcmd']['sql_compact32']['url']               = 'http://download.microsoft.com/download/SSCERuntime_x86-ENU.msi'
  default['vsdbcmd']['sql_compact32']['checksum']          = ''
  default['vsdbcmd']['sql_compact32']['package_name']      = 'Microsoft SQL Server Compact 3.5 SP2 ENU'


