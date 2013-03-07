#
# Cookbook Name:: wt_streaming_barebones
# Attributes:: default
#
# Copyright 2013, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_streaming_barebones']['user'] = "webtrends"
default['wt_streaming_barebones']['group'] = "webtrends"
default['wt_streaming_barebones']['java_opts'] = "-Xms1024m -Djava.net.preferIPv4Stack=true"
default['wt_streaming_barebones']['download_url'] = ""
default['wt_streaming_barebones']['port'] = 8085
default['wt_streaming_barebones']['auth_jwt_audience'] = "auth.webtrends.com"
default['wt_streaming_barebones']['auth_jwt_scope'] = "sapi.webtrends.com"
