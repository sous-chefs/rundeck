#
# Cookbook Name:: wt_openldap
# Attributes:: default
#
# Copyright 2013, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

# openldap package version
default['wt_openldap']['version'] = '2.4.28-1.1ubuntu4.2'

# ldap common name if different than node name (used for ssl certificate)
default['wt_openldap']['common_name'] = nil

# backup options
default['wt_openldap']['server_backup']['num_backups_retained'] = 7
default['wt_openldap']['server_backup']['backup_nfs_mount']     = nil
default['wt_openldap']['server_backup']['mount_path']           = nil
