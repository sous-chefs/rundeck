# Author:: Aaron Stanley (<aaron.stanley@webtrends.com>)
# Cookbook Name:: dbproject_prereqs
# Attribute:: default
#
# Copyright:: Copyright (c) 2013 Webtrends Inc.
#
#

  default['dbproject_prereqs']['native_client']['url']               = 'http://download.microsoft.com/download/sqlncli_x64.msi'
  default['dbproject_prereqs']['native_client']['checksum']          = ''
  default['dbproject_prereqs']['native_client']['package_name']      = 'Microsoft SQL Server 2008 R2 Native Client'

  default['dbproject_prereqs']['command_line_utils']['url']          = 'http://download.microsoft.com/download/SqlCmdLnUtils.msi'
  default['dbproject_prereqs']['command_line_utils']['checksum']     = ''
  default['dbproject_prereqs']['command_line_utils']['package_name'] = 'Microsoft SQL Server 2008 R2 Command Line Utilities'

  default['dbproject_prereqs']['clr_types']['url']                   = 'http://download.microsoft.com/download/SQLSysClrTypes_x64.msi'
  default['dbproject_prereqs']['clr_types']['checksum']              = ''
  default['dbproject_prereqs']['clr_types']['package_name']          = 'Microsoft SQL Server System CLR Types (x64)'

  default['dbproject_prereqs']['smo']['url']                         = 'http://download.microsoft.com/download/SharedManagementObjects_x64.msi'
  default['dbproject_prereqs']['smo']['checksum']                    = ''
  default['dbproject_prereqs']['smo']['package_name']                = 'Microsoft SQL Server 2008 R2 Management Objects (x64)'

  default['dbproject_prereqs']['sql_compact64']['url']	             = 'http://download.microsoft.com/download/SSCERuntime_x64-ENU.msi'
  default['dbproject_prereqs']['sql_compact64']['checksum']          = ''
  default['dbproject_prereqs']['sql_compact64']['package_name']      = 'Microsoft SQL Server Compact 3.5 SP2 x64 ENU'

  default['dbproject_prereqs']['sql_compact32']['url']               = 'http://download.microsoft.com/download/SSCERuntime_x86-ENU.msi'
  default['dbproject_prereqs']['sql_compact32']['checksum']          = ''
  default['dbproject_prereqs']['sql_compact32']['package_name']      = 'Microsoft SQL Server Compact 3.5 SP2 ENU'


