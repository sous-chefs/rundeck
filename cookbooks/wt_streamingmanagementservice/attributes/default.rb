#
# Cookbook Name:: wt_streamingmanagementservice
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_streamingmanagementservice']['user'] = "webtrends"
default['wt_streamingmanagementservice']['group'] = "webtrends"
default['wt_streamingmanagementservice']['java_opts'] = "-Xms1024m -Djava.net.preferIPv4Stack=true"
default['wt_streamingmanagementservice']['download_url'] = ""
default['wt_streamingmanagementservice']['port'] = 8080
default['wt_streamingmanagementservice']['jmx_port'] = 9999
default['wt_streamingmanagementservice']['healthcheck_port'] = 9000
default['wt_streamingmanagementservice']['sms_service_url'] = ""
