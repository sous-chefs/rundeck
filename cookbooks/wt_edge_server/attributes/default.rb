#
# Cookbook Name:: wt_collection_services
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_edge_server']['user']         = "webtrends"
default['wt_edge_server']['group']        = "webtrends"
default['wt_edge_server']['download_url'] = ""
default['wt_edge_server']['port']         = 8081
default['wt_edge_server']['java_opts']    = "-Xms1024m -Djava.net.preferIPv4Stack=true"
default['wt_edge_server']['jmx_port']     = 10001
default['wt_edge_server']['log_level']     = "INFO"
