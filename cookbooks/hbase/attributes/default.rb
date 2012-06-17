#
# Cookbook Name:: hbase
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default[:hbase][:version] = "0.92.0"

# hbase-env.sh
default[:hbase][:env][:HBASE_HEAPSIZE] = 1000
default[:hbase][:env][:HBASE_MANAGES_ZK] = "true"

# hbase-site.xml
default[:hbase][:site][:zookeeper_clientport] = 2181
default[:hbase][:site][:zookeeper_quorum] = "localhost"