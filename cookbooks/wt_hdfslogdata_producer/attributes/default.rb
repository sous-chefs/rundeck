#
# Cookbook Name:: wt_hdfslogdata_producer
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_hdfslogdata_producer']['user']         = "webtrends"
default['wt_hdfslogdata_producer']['group']        = "webtrends"
default['wt_hdfslogdata_producer']['download_url'] = ""
default['wt_hdfslogdata_producer']['port']         = 8080
default['wt_hdfslogdata_producer']['java_opts']    = "-Xms1024m -Djava.net.preferIPv4Stack=true"
default['wt_hdfslogdata_producer']['jmx_port']     = 10000
default['wt_hdfslogdata_producer']['kafka_connect_timeout_ms'] = 100
