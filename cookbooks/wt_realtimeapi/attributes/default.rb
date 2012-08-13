#
# Cookbook Name:: wt_realtimeapi
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_realtimeapi']['user']         = "webtrends"
default['wt_realtimeapi']['group']        = "webtrends"
default['wt_realtimeapi']['download_url'] = ""
default['wt_realtimeapi']['port']         = "8082"
default['wt_realtimeapi']['java_opts']    = "-Xms1024m -Djava.net.preferIPv4Stack=true"