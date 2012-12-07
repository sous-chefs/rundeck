#
# Cookbook Name:: wt_streamingconfigservice
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_streamingconfigservice']['user'] = "webtrends"
default['wt_streamingconfigservice']['group'] = "webtrends"
default['wt_streamingconfigservice']['java_opts'] = "-Xms1024m -Djava.net.preferIPv4Stack=true"
default['wt_streamingconfigservice']['download_url'] = ""
default['wt_streamingconfigservice']['port'] = 8080
default['wt_streamingconfigservice']['camdbname'] = "cam"
default['wt_streamingconfigservice']['camdbserver'] = ""
default['wt_streamingconfigservice']['includeUnmappedAnalyticsIds'] = "true"
default['wt_streamingconfigservice']['jmx_port'] = 9999
default['wt_streamingconfigservice']['healthcheck_port'] = 9000