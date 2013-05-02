#
# Cookbook Name:: wt_streaming_collection
# Attributes:: default
#
# Copyright 2013, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_streaming_collection']['user']           = "webtrends"
default['wt_streaming_collection']['group']          = "webtrends"
default['wt_streaming_collection']['kafka_connect_timeout_ms'] = 100

default["wt_streaming_collection"]["scs_worker_count"] = 5
default["wt_streaming_collection"]["dc_worker_count"] = 5
default["wt_streaming_collection"]["id_worker_count"] = 2
default["wt_streaming_collection"]["kafka_worker_count"] = 5

