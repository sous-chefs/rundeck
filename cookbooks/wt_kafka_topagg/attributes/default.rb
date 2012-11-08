#
# Cookbook Name:: wt_kafka_topagg
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_kafka_topagg']['user']      = "webtrends"
default['wt_kafka_topagg']['group']     = "webtrends"
default['wt_kafka_topagg']['port']      = 8080
default['wt_kafka_topagg']['java_opts'] = "-Xms1024m -Djava.net.preferIPv4Stack=true"
default['wt_kafka_topagg']['jmx_port']  = 10000

default['wt_kafka_topagg']['name'] = "topagg"
default['wt_kafka_topagg']['download_url'] = ""
default['wt_kafka_topagg']['edge_kafka_sources'] = []
default['wt_kafka_topagg']['agg_bkr_zk_timeout_ms'] = 2000