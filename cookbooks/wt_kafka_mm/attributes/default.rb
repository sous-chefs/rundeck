#
# Author: Jeff Berger (<jeff.berger@webtrends.com>)
# Cookbook Name:: wt_kafka_mm
# Recipe:: default
#
# Copyright 2012, Webtrends
#

default['wt_kafka_mm']['user']         = "webtrends"
default['wt_kafka_mm']['group']        = "webtrends"
default['wt_kafka_mm']['java_opts']    = "-Xms1024m -Djava.net.preferIPv4Stack=true"
default['wt_kafka_mm']['jmx_port']    = "10000"

default['wt_kafka_mm']['topic_white_list'] = ".*RawHits"

