#
# Cookbook Name:: hive
# Attribute:: default
# Author:: Sean McNamara(<sean.mcnamara@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#

# cluster name
default[:hive][:cluster_name] = 'default'

# hive cluster attributes
default[:hive][:default][:path] = '/usr/share/hive/lib'
default[:hive][:default][:version] = '0.8.1'
default[:hive][:default][:download_url] = 'http://repo.staging.dmz/repo/linux/hive/hive-0.8.1-bin.tar.gz'

# metastore information
default[:hive][:default][:metastore][:connection_url] = ''
default[:hive][:default][:metastore][:connector] = 'mysql'
default[:hive][:default][:metastore][:dbuser] = 'root'
default[:hive][:default][:metastore][:dbpass] = ''
