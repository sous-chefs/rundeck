#
# Cookbook Name:: wt_streaming_topagg
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_streaming_topagg']['user']      = "webtrends"
default['wt_streaming_topagg']['group']     = "webtrends"
default['wt_streaming_topagg']['port']      = 8080
default['wt_streaming_topagg']['java_opts'] = "-Xms1024m -Djava.net.preferIPv4Stack=true"
default['wt_streaming_topagg']['jmx_port']  = 10000

default['wt_streaming_topagg']['name'] = "topagg"
default['wt_streaming_topagg']['download_url'] = ""
default['wt_streaming_topagg']['edge_kafka_sources'] = []
default['wt_streaming_topagg']['agg_bkr_zk_timeout_ms'] = 2000