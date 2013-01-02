#
# Cookbook Name:: wt_stream_processor
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_stream_processor']['user']           = "webtrends"
default['wt_stream_processor']['group']          = "webtrends"
default['wt_stream_processor']['download_url']   = ""
default['wt_stream_processor']['port']           = 8080
default['wt_stream_processor']['java_opts']      = "-Xms2048m -XX:+UseG1GC -Djava.net.preferIPv4Stack=true"
default['wt_stream_processor']['jmx_port']       = 9999
default['wt_stream_processor']['log_dir']        = "/var/log/webtrends/streamprocessor"
