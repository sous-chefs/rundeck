#
# Author:: Sean McNamara(<sean.mcnamara@webtrends.com>)
# Cookbook Name:: hive
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default[:hive][:path] = "/usr/share/hive/lib/"

default[:hive][:version] = "0.8.1"
default[:hive][:download_url] = "http://mirror.uoregon.edu/apache/hive/hive-0.8.1/"
default[:hive][:tarball] = "hive-0.8.1-bin.tar.gz"

default[:hive][:metastore][:connection_url] = ""
default[:hive][:metastore][:connector] = "mysql"
default[:hive][:metastore][:dbuser] = "root"
default[:hive][:metastore][:dbpass] = ""