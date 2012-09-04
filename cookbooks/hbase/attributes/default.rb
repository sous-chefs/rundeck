#
# Cookbook Name:: hbase
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

# cluster name
default[:hbase][:cluster_name] = 'default'

# hbase cluster attributes
default[:hbase][:default][:version] = '0.92.0'
default[:hbase][:default][:download_url] = 'http://repo.staging.dmz/repo/linux/hbase/hbase-0.92.0.tar.gz'
default[:hbase][:default][:log_dir] = '/var/log/hbase'

# hbase-env.sh
default[:hbase][:default][:env][:HBASE_HEAPSIZE] = 1000
default[:hbase][:default][:env][:HBASE_MANAGES_ZK] = 'true'

# hbase-site.xml
default[:hbase][:default][:site][:zookeeper_clientport] = 2181
default[:hbase][:default][:site][:zookeeper_quorum] = 'localhost'
default[:hbase][:default][:site][:cluster_distributed] = 'true'
default[:hbase][:default][:site][:master_info_port] = 60010

# logging levels

#log4j.logger.org.apache.zookeeper
default[:hbase][:default][:log4j][:zookeeper] = 'INFO'
#log4j.logger.org.apache.hadoop.hbase
default[:hbase][:default][:log4j][:hbase] = 'INFO'
#log4j.logger.org.apache.hadoop.hbase.zookeeper.ZKUtil
default[:hbase][:default][:log4j][:ZKUtil] = 'INFO'
#log4j.logger.org.apache.hadoop.hbase.zookeeper.ZooKeeperWatcher
default[:hbase][:default][:log4j][:ZooKeeperWatcher] = 'INFO'

