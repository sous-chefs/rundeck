#
# Cookbook Name:: hbase
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default[:hbase][:version] = "0.92.0"
default[:hbase][:download_url] = "http://repo.staging.dmz/repo/linux/hbase/hbase-0.92.0.tar.gz"

# hbase-env.sh
default[:hbase][:env][:HBASE_HEAPSIZE] = 1000
default[:hbase][:env][:HBASE_MANAGES_ZK] = "true"

# hbase-site.xml
default[:hbase][:site][:zookeeper_clientport] = 2181
default[:hbase][:site][:zookeeper_quorum] = "localhost"
default[:hbase][:site][:cluster_distributed] = "true"
default[:hbase][:site][:master_info_port] = 60010

# logging levels

#log4j.logger.org.apache.zookeeper
default[:hbase][:log4j][:zookeeper] = "INFO"
#log4j.logger.org.apache.hadoop.hbase
default[:hbase][:log4j][:hbase] = "INFO"
#log4j.logger.org.apache.hadoop.hbase.zookeeper.ZKUtil
default[:hbase][:log4j][:ZKUtil] = "INFO"
#log4j.logger.org.apache.hadoop.hbase.zookeeper.ZooKeeperWatcher
default[:hbase][:log4j][:ZooKeeperWatcher] = "INFO"
