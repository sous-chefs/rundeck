#
# Cookbook Name:: Oozie
# Attribute:: default
# Author:: Robert Towne(<robert.towne@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#


# hive cluster attributes
default['oozie']['user']             	= "hadoop"
default['oozie']['group']           	= "hadoop"
default['oozie']['install_path']	= '/usr/share'
default['oozie']['version']      	= '3.3.0'
default['oozie']['download_url'] 	= 'http://repo.staging.dmz/repo/linux/oozie/oozie-3.3.0.tar.gz'
default['oozie']['log_dir'] 		= '/var/log/oozie'


# metastore information
default['oozie']['metastore']['connection_url'] = ''
default['oozie']['metastore']['connector'] = 'mysql'
default['oozie']['metastore']['dbuser'] = 'root'
default['oozie']['metastore']['dbpass'] = ''


# oozie-site.xml 



