#
# Cookbook Name:: wt_thumbnailcapture
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default['wt_thumbnailcapture']['user'] = "webtrends"
default['wt_thumbnailcapture']['group'] = "webtrends"
default['wt_thumbnailcapture']['download_url'] = ""

default['wt_thumbnailcapture']['java_opts'] = "-Xms1024m -Djava.net.preferIPv4Stack=true"

# optionally specify the environment where ZooKeeper nodes are located
default['wt_thumbnailcapture']['zookeeper_env'] = nil
