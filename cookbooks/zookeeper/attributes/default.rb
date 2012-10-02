#
# Cookbook Name:: zookeeper
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

# cluster name
default[:zookeeper][:cluster_name] = 'default'

default[:zookeeper][:default][:version] = '3.3.6'
default[:zookeeper][:default][:download_url] = 'http://mirror.uoregon.edu/apache/zookeeper/zookeeper-3.3.6/zookeeper-3.3.6.tar.gz'

default[:zookeeper][:default][:install_dir] = '/opt/zookeeper'
default[:zookeeper][:default][:config_dir] = '/etc/zookeeper'
default[:zookeeper][:default][:log_dir] = '/var/log/zookeeper'
default[:zookeeper][:default][:data_dir] = '/var/zookeeper'
default[:zookeeper][:default][:snapshot_dir] = '/var/zookeeper/snapshots'

default[:zookeeper][:default][:tick_time] = 2000
default[:zookeeper][:default][:init_limit] = 10
default[:zookeeper][:default][:sync_limit] = 5
default[:zookeeper][:default][:client_port] = 2181
default[:zookeeper][:default][:snapshot_num] = 3
default[:zookeeper][:default][:max_client_cnxns] = 60

default[:zookeeper][:default][:jmx_port] = 10201
