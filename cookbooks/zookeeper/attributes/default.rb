#
# Cookbook Name:: zookeeper
# Attributes:: default
#
# Copyright 2012, Webtrends Inc.
#

default[:zookeeper][:version] = "3.3.6"
default[:zookeeper][:download_url] = "http://mirror.uoregon.edu/apache/zookeeper/zookeeper-#{node[:zookeeper][:version]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz"

default[:zookeeper][:install_dir] = "/opt/zookeeper"
default[:zookeeper][:config_dir] = "/etc/zookeeper"
default[:zookeeper][:log_dir] = '/var/log/zookeeper'
default[:zookeeper][:data_dir] = "/var/zookeeper"
default[:zookeeper][:snapshot_dir] = "#{default[:zookeeper][:data_dir]}/snapshots"

default[:zookeeper][:tick_time] = 2000
default[:zookeeper][:init_limit] = 10
default[:zookeeper][:sync_limit] = 5
default[:zookeeper][:client_port] = 2181
default[:zookeeper][:snapshot_num] = 3


default[:zookeeper][:jmx_port] = 10201