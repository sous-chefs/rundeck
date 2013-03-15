#
# Cookbook Name:: wt_thumbnailcapture
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default['wt_thumbnailcapture']['user'] = "webtrends"
default['wt_thumbnailcapture']['group'] = "webtrends"
default['wt_thumbnailcapture']['download_url'] = ""
default['wt_thumbnailcapture']['port'] = 8085
default['wt_thumbnailcapture']['thread_pool_size'] = 500
default['wt_thumbnailcapture']['java_opts'] = "-Xms1024m -Djava.net.preferIPv4Stack=true"
default['wt_thumbnailcapture']['memcache.cacheexpireseconds']=86400
default['wt_thumbnailcapture']['jmx_port'] = 9999
default['wt_thumbnailcapture']['graphite_enabled'] = true
default['wt_thumbnailcapture']['graphite_interval'] = 5
default['wt_thumbnailcapture']['graphite_vmmetrics'] = true
default['wt_thumbnailcapture']['graphite_regex'] = ""

default['wt_thumbnailcapture']['healthcheck_port'] = 9000
default['wt_thumbnailcapture']['thumbnailcapture_service_url'] = ""

# optionally specify the environment where ZooKeeper nodes are located
default['wt_thumbnailcapture']['zookeeper_env'] = nil
