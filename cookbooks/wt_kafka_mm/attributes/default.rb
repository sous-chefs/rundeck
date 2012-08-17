#
# Author: Jeff Berger (<jeff.berger@webtrends.com>)
# Cookbook Name:: wt_kafka_mm
# Recipe:: default
#
# Copyright 2012, Webtrends
#

default['wt_mirrormaker']['user']         = "webtrends"
default['wt_mirrormaker']['group']        = "webtrends"
default['wt_mirrormaker']['java_opts']    = "-Xms1024m -Djava.net.preferIPv4Stack=true"
default['wt_mirrormaker']['jmx_port']    = "10000"

default['wt_mirrormaker']['topic_white_list'] = ".*RawHits"

