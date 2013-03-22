# Author:: Aaron Stanley (<aaron.stanley@webtrends.com>)
# Cookbook Name:: vsdbcmd
# Attribute:: default
#
# Copyright:: Copyright (c) 2013 Webtrends Inc.
#
#
  default['vsdbcmd']['accept_eula'] = false

  default['vsdbcmd']['native_client']['url']               = 'http://repo.staging.dmz/repo/windows/sqlserver/prereqs/sqlncli_x64.msi'
  default['vsdbcmd']['native_client']['checksum']          = '012aca6cef50ed784f239d1ed5f6923b741d8530b70d14e9abcb3c7299a826cc'
  default['vsdbcmd']['native_client']['package_name']      = 'Microsoft SQL Server 2008 R2 Native Client'

  default['vsdbcmd']['command_line_utils']['url']          = 'http://repo.staging.dmz/repo/windows/sqlserver/prereqs/SqlCmdLnUtils.msi'
  default['vsdbcmd']['command_line_utils']['checksum']     = '0f1d388d142d9252e27fe563fbf6e21d7ae64333d6152e14c9aaee9e50564c80'
  default['vsdbcmd']['command_line_utils']['package_name'] = 'Microsoft SQL Server 2008 R2 Command Line Utilities'

  default['vsdbcmd']['clr_types']['url']                   = 'http://repo.staging.dmz/repo/windows/sqlserver/prereqs/SQLSysClrTypes_x64.msi'
  default['vsdbcmd']['clr_types']['checksum']              = '3d889b8d2c4eb92126c4dd51f73b59d74e11d74526619e2afa8711f052f1d7a3'
  default['vsdbcmd']['clr_types']['package_name']          = 'Microsoft SQL Server System CLR Types (x64)'

  default['vsdbcmd']['smo']['url']                         = 'http://repo.staging.dmz/repo/windows/sqlserver/prereqs/SharedManagementObjects_x64.msi'
  default['vsdbcmd']['smo']['checksum']                    = '1ec4e315c26e25002597fc63bdfd7ac8a4089478ebc3ea14ddd7560e003eb8a4'
  default['vsdbcmd']['smo']['package_name']                = 'Microsoft SQL Server 2008 R2 Management Objects (x64)'

  default['vsdbcmd']['sql_compact32']['url']               = 'http://repo.staging.dmz/repo/windows/sqlserver/prereqs/SSCERuntime_x86-ENU.msi'
  default['vsdbcmd']['sql_compact32']['checksum']          = '99b5f0c1cc7fe40120a36fb760cc7c646edef5916695d6ecd8d41e8bba9b1c60'
  default['vsdbcmd']['sql_compact32']['package_name']      = 'Microsoft SQL Server Compact 3.5 SP2 ENU'  

  default['vsdbcmd']['sql_compact64']['url']	           = 'http://repo.staging.dmz/repo/windows/sqlserver/prereqs/SSCERuntime_x64-ENU.msi'
  default['vsdbcmd']['sql_compact64']['checksum']          = 'fcc1110c9ad0fb3e2f8787103a2a7549c16b0935e1808c2ee1ea016149fa08b8'
  default['vsdbcmd']['sql_compact64']['package_name']      = 'Microsoft SQL Server Compact 3.5 SP2 x64 ENU'



